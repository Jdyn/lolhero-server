defmodule LolHero.Order do
  use LolHero.Web, :model

  alias LolHero.{Repo, Order, User, Category, Product, Variant, Collection}
  alias LolHero.Services.Boosts

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

  def delete_all() do
    Order
    |> Repo.delete_all()
  end

  def update(%Order{} = order, attrs) do
    order
    |> update_changeset(attrs)
    |> Repo.update()
  end

  def changeset(order, attrs) do
    keys = ~w(type details tracking_id status paid price note email user_id booster_id)a

    order
    |> cast(attrs, keys)
    |> validate_required([:type, :details, :tracking_id, :status])
    |> validate_required([:email], message: "Please enter your email to complete the order.")
    |> validate_inclusion(:status, ["open", "in progress", "completed", "paused", "active"])
    |> foreign_key_constraint(:user_id)
  end

  def update_changeset(order, attrs) do
    order
    |> cast(attrs, [:status, :booster_id, :is_complete, :is_active])
    |> validate_inclusion(:status, [
      "open",
      "in progress",
      "completed",
      "paused",
      "active",
      "initialized"
    ])
    |> validate_status()
    |> foreign_key_constraint(:booster_id)
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

  def status_changeset(order, attrs) do
    order
    |> cast(attrs, [:status])
    |> validate_inclusion(:status, ["paused", "active"])
  end

  def initiation_changeset(order, attrs) do
    detail_keys = ~w(primaryRole secondaryRole summonerName)
    account_keys = ~w(username password)

    order
    |> cast(attrs, [:note, :details, :account_details, :booster_id])
    |> validate_required([:details, :account_details])
    |> validate_keys(:details, detail_keys)
    |> put_change(:is_editable, false)
    |> put_change(:status, "initialized")
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
          kind: "debit"
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

    %{
      "collectionName" => collection_title,
      "collectionId" => collection_id,
      "startRank" => start_rank,
      "isExpress" => is_express,
      "isIncognito" => is_incognito,
      "isUnrestricted" => is_unrestricted,
      "boostType" => boost_type
    } = details

    %{
      "express" => express_price,
      "incognito" => incognito_price,
      "unrestricted" => unrestricted_price
    } = Boosts.get_prices(boost_type, "modifiers")

    case collection_title do
      "Division Boost" ->
        %{"desiredRank" => desired_rank} = details

        {base_price, start_rank_price} =
          Boosts.get_base_prices(start_rank, desired_rank, collection_id)

        price =
          base_price
          |> is_express(express_price, is_express)
          |> is_incognito(incognito_price, is_incognito)
          |> is_unrestricted(unrestricted_price, is_unrestricted)
          |> calculate_queue(details)
          |> calculate_lp(start_rank_price, details)
          |> Decimal.round(2)
          |> Decimal.to_float()

        put_change(changeset, :price, price)

      _ ->
        %{"desiredAmount" => desired_amount} = details

        base_price =
          Repo.one(
            from(v in Variant,
              where: v.collection_id == ^collection_id and v.product_id == ^start_rank,
              select: v.base_price
            )
          )

        price =
          base_price
          |> Decimal.mult(desired_amount)
          |> is_express(express_price, is_express)
          |> is_incognito(incognito_price, is_incognito)
          |> is_unrestricted(unrestricted_price, is_unrestricted)
          |> calculate_queue(details)
          |> Decimal.round(2)
          |> Decimal.to_float()

        put_change(changeset, :price, price)
    end
  end

  def put_title(changeset) do
    details = get_field(changeset, :details)

    case Boosts.get_title(details) do
      {:ok, title} ->
        put_change(changeset, :title, title)

      {:error, reason} ->
        add_error(changeset, :collection_id, reason)
    end
  end

  defp is_express(total, price, false), do: total
  defp is_express(total, price, true), do: Decimal.mult(total, price)

  defp is_incognito(total, price, false), do: total
  defp is_incognito(total, price, true), do: Decimal.mult(total, price)

  defp is_unrestricted(total, price, false), do: total
  defp is_unrestricted(total, price, true), do: Decimal.mult(total, price)

  defp calculate_lp(total, start_rank_price, details) do
    %{"lp" => lp, "boostType" => boost_type} = details

    lp_string = Integer.to_string(lp)
    lp_prices = Boosts.get_prices(boost_type, "lp")
    %{^lp_string => lp_price} = lp_prices

    case lp do
      100 ->
        calculate_promos(total, start_rank_price, details)

      _ ->
        diff =
          start_rank_price
          |> Decimal.sub(Decimal.mult(start_rank_price, lp_price))
          |> Decimal.mult(100)
          |> Decimal.round()
          |> Decimal.div(100)

        Decimal.sub(total, diff)
    end
  end

  defp calculate_lp(total, _start_rank_price, _details), do: total

  defp calculate_queue(total, details) do
    %{"boostType" => boost_type, "queue" => queue} = details
    queue_prices = Boosts.get_prices(boost_type, "queues")

    case Map.has_key?(queue_prices, queue) do
      true ->
        Decimal.mult(total, queue_prices[queue])

      false ->
        total
    end
  end

  defp calculate_promos(total, start_rank_price, details) do
    %{"promos" => promos, "boostType" => boost_type} = details

    if promos != nil do
      promo_prices = Boosts.get_prices(boost_type, "promotions")

      sum =
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

      promo_string = Integer.to_string(sum)
      %{^promo_string => promo_price} = promo_prices

      diff =
        start_rank_price
        |> Decimal.sub(Decimal.mult(start_rank_price, promo_price))
        |> Decimal.mult(100)
        |> Decimal.round()
        |> Decimal.div(100)

      Decimal.sub(total, diff)
    end
  end

  def validate_keys(changeset, field, required_keys \\ []) do
    details = get_field(changeset, field)

    Enum.reduce(required_keys, changeset, fn key, changeset ->
      if Map.has_key?(details, key) do
        if details[key] !== "" do
          changeset
        else
          add_error(changeset, field, "\"#{key}\" must not be empty.")
        end
      else
        add_error(changeset, field, "\"#{key}\" must exist.")
      end
    end)
  end

  def validate_status(changeset) do
    status = get_field(changeset, :status)

    if status == "completed" do
      changeset
      |> put_change(:is_complete, true)
      |> put_change(:is_active, false)
    else
      changeset
      |> put_change(:is_complete, false)
      |> put_change(:is_active, true)
    end
  end
end
