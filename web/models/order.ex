defmodule LolHero.Order do
  use LolHero.Web, :model

  alias LolHero.{Repo, Order, User, Collection, Category, Product, Variant}

  schema "orders" do
    field(:title, :string)
    field(:price, :decimal)
    field(:type, :string)
    field(:email, :string)
    field(:transaction_id, :string)
    field(:tracking_id, :string)
    field(:note, :string)
    field(:is_editable, :boolean, default: false)
    field(:is_active, :boolean, default: false)
    field(:is_complete, :boolean, default: false)
    field(:status, :string, default: "open")
    field(:paid, :boolean, default: false)
    field(:details, :map)
    field(:account_details, :map)

    belongs_to(:booster, User)
    belongs_to(:user, User)

    timestamps()
  end

  def create(%{"type" => type} = attrs) do
    case type do
      "boost" ->
        %Order{}
        |> changeset(attrs)
        |> boost_changeset(attrs)
        |> Repo.insert()

      _ ->
        %Order{}
        |> changeset(attrs)
        |> Repo.insert()
    end
  end

  def find_all() do
    Order
    |> Repo.all()
  end

  def find_by(param) do
    Repo.get_by(Order, param)
  end

  def changeset(order, attrs) do
    keys = ~w(type details tracking_id status paid price note email user_id booster_id)a

    order
    |> cast(attrs, keys)
    |> validate_required([:type, :details, :tracking_id, :status])
    |> validate_required([:email], message: "Please enter your email to complete the order.")
    |> validate_inclusion(:status, ["open", "incomplete", "in progress", "completed"])
    |> foreign_key_constraint(:user_id)
  end

  def boost_changeset(order, attrs) do
    keys = ~w(lp startRank collectionId queue server isExpress isUnrestricted isIncognito)

    order
    |> validate_inclusion(:type, ["boost"])
    |> validate_keys(:details, keys)
    |> put_price()
    |> put_title()
    |> create_transaction(attrs)
  end

  def initiation_changeset(order, attrs) do
    detail_keys = ~w(primaryRole secondaryRole summonerName)
    account_keys = ~w(username password)

    order
    |> cast(attrs, [:note, :details, :account_details])
    |> validate_required([:note, :details, :account_details])
    |> validate_keys(:details, detail_keys)
    |> put_change(:is_editable, false)
    |> validate_keys(:account_details, account_keys)
  end

  def create_transaction(changeset, attrs) do
    price = get_field(changeset, :price)
    title = get_field(changeset, :title)
    tracking_id = get_field(changeset, :tracking_id)

    payload = %{
      amount: price,
      payment_method_nonce: attrs["nonce"],
      purchase_order_number: tracking_id,
      tax_exempt: true,
      line_items: [
        %{
          description: title,
          unit_amount: price,
          total_amount: price,
          quantity: 1,
          name: "League Of Legends Boost",
          kind: "debit",
          description: title
        }
      ]
    }

    case Braintree.Transaction.sale(payload) do
      {:ok, transaction} ->
        %{status: status, id: id} = transaction

        if status == "authorized" do
          changeset
          |> put_change(:transaction_id, id)
          |> put_change(:paid, true)
          |> put_change(:is_editable, true)
          |> put_change(:is_active, true)
        end

      {:error, braintreeError} ->
        %Braintree.ErrorResponse{message: message} = braintreeError

        add_error(changeset, :transaction_id, message)
    end
  end

  def put_price(changeset) do
    details = get_field(changeset, :details)
    %{"collectionId" => id} = details

    case details do
      %{"desiredRank" => desired_rank, "desiredAmount" => desired_amount} = details ->
        add_error(changeset, :details, "cannot contain desired_rank and desired_amount")

      %{"desiredRank" => desired_rank, "startRank" => start_rank} = details ->
        items = Repo.all(Variant.boost_price_query(id, start_rank, desired_rank))
        modifiers = Variant.find_by_assoc_titles(details["boostType"], "modifiers")
        start_rank_price = Enum.at(items, 0)

        base_price =
          items
          |> Enum.reduce(0, fn item, acc -> Decimal.add(acc, item) end)
          |> is_express(modifiers, details["isExpress"])
          |> is_incognito(modifiers, details["isIncognito"])
          |> is_unrestricted(modifiers, details["isUnrestricted"])
          |> calculateQueueType(details)
          |> calculateLP(start_rank_price, details)
          |> Decimal.round(2)
          |> Decimal.to_float()

        put_change(changeset, :price, base_price)

      %{"startRank" => start_rank, "desiredAmount" => desired_amount} = details ->
        modifiers = Variant.find_by_assoc_titles(details["boostType"], "modifiers")

        item =
          Repo.one(
            from(v in Variant,
              where: v.collection_id == ^id and v.product_id == ^start_rank,
              select: v.base_price
            )
          )

        base_price =
          item
          |> Decimal.mult(desired_amount)
          |> is_express(modifiers, details["isExpress"])
          |> is_incognito(modifiers, details["isIncognito"])
          |> is_unrestricted(modifiers, details["isUnrestricted"])
          |> calculateQueueType(details)
          |> Decimal.round(2)
          |> Decimal.to_float()

        put_change(changeset, :price, base_price)

      true ->
        add_error(changeset, :details, "rank params cannot be null")
    end
  end
  
  def put_title(changeset) do
    details = get_field(changeset, :details)

    case Repo.one(Category.title_query(details["collectionId"])) do
      [category, collection] ->
        case Repo.all(Product.ranks_query(details["startRank"], details["desiredRank"])) do
          [start, finish] ->
            title =
              format_title(
                "ranks",
                category,
                collection,
                details["queue"],
                start,
                finish
              )

            put_change(changeset, :title, title)

          [start] ->
            title =
              format_title(
                "games",
                category,
                collection,
                details["queue"],
                start,
                details["desiredAmount"]
              )

            put_change(changeset, :title, title)
        end

      _ ->
        add_error(changeset, :collection_id, "invalid collectionId")
    end
  end

  defp format_title(type, category, collection, queue, start_rank, item) do
    case type do
      "ranks" ->
        "#{collection} - #{start_rank} to #{item}"

      # "#{String.upcase(category)} BOOST | #{String.upcase(queue)} QUEUE | #{collection} - #{
      #   start_rank
      # } to #{item}"

      "games" ->
        "#{item} #{collection} - #{start_rank}"
        # category <> " | " <> Integer.to_string(item) <> " " <> collection <> " - " <> start_rank
    end
  end

  defp is_express(price, details, false), do: price

  defp is_express(price, %{"express" => express_price}, true),
    do: Decimal.mult(price, express_price)

  defp is_incognito(price, details, false), do: price

  defp is_incognito(price, %{"incognito" => incognito_price}, true),
    do: Decimal.mult(price, incognito_price)

  defp is_unrestricted(price, details, false), do: price

  defp is_unrestricted(price, %{"unrestricted" => unrestricted_price}, true),
    do: Decimal.mult(price, unrestricted_price)

  defp calculateLP(price, start_rank_price, %{"lp" => lp, "boostType" => boost_type} = details) do
    lp_prices = Variant.find_by_assoc_titles(boost_type, "lp")
    lp_string = Integer.to_string(lp)

    %{^lp_string => lp_price} = lp_prices

    case lp do
      100 ->
        calculatePromos(price, details, start_rank_price)

      _ ->
        Decimal.sub(
          price,
          Decimal.div(
            Decimal.round(
              Decimal.mult(
                Decimal.sub(start_rank_price, Decimal.mult(start_rank_price, lp_price)),
                100
              )
            ),
            100
          )
        )
    end
  end

  defp calculateLP(price, start_rank_price, details), do: price

  defp calculateQueueType(price, %{"queue" => queue, "boostType" => boost_type}) do
    queue_prices = Variant.find_by_assoc_titles(boost_type, "queues")

    case Map.has_key?(queue_prices, queue) do
      true ->
        Decimal.mult(price, queue_prices[queue])

      false ->
        price
    end
  end

  defp calculateQueueType(price, details), do: price

  defp calculatePromos(
         price,
         %{"promos" => promos, "boostType" => boost_type} = details,
         start_rank_price
       ) do
    if promos != nil do
      promo_prices = Variant.find_by_assoc_titles(boost_type, "promotions")

      total =
        Enum.reduce(promos, 0, fn promo, acc ->
          cond do
            promo == "X" ->
              acc + 0

            promo == "W" ->
              acc + 1

            promo == "L" ->
              acc - 1
          end
        end)

      promo_string = Integer.to_string(total)
      %{^promo_string => promo_price} = promo_prices

      Decimal.sub(
        price,
        Decimal.div(
          Decimal.round(
            Decimal.mult(
              Decimal.sub(start_rank_price, Decimal.mult(start_rank_price, promo_price)),
              100
            )
          ),
          100
        )
      )
    end
  end

  def validate_keys(changeset, field, required_keys \\ []) do
    details = get_field(changeset, field)

    Enum.reduce(required_keys, changeset, fn key, changeset ->
      if Map.has_key?(details, key) do
        changeset
      else
        add_error(changeset, field, "Key: \"#{key}\" must exist.")
      end
    end)
  end
end
