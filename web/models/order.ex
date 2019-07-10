defmodule LolHero.Order do
  use LolHero.Web, :model

  alias LolHero.{Repo, Order, Collection, Category, Product, Variant}

  schema "orders" do
    field(:title, :string)
    field(:price, :decimal)
    field(:type, :string)
    field(:tracking_id, :string)
    field(:note, :string)
    field(:status, :string, default: "unpaid")
    field(:paid, :boolean, default: false)
    field(:details, :map)

    timestamps()
  end

  def create(%{"type" => type} = attrs) do
    case type do
      "boost" ->
        %Order{}
        |> changeset(attrs)
        |> boost_changeset()
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

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:type, :details, :tracking_id, :status, :paid, :price, :note])
    |> validate_required([:type, :details, :tracking_id, :status])
    |> validate_inclusion(:type, ["boost"])
    |> validate_inclusion(:status, ["not_started", "incomplete", "in_progress", "completed"])

    # |> foreign_key_constraint(:collection_id)
  end

  def boost_changeset(changeset) do
    changeset
    |> validate_keys(:details, [
      "lp",
      "start_rank",
      "collection_id",
      "queue",
      "server",
      "is_express",
      "is_unrestricted",
      "is_incognito"
    ])
    |> put_title()
    |> put_price()
  end

  def put_price(changeset) do
    details = get_field(changeset, :details)
    %{"collection_id" => id} = details

    case details do
      %{"desired_rank" => desired_rank, "desired_amount" => desired_amount} = details ->
        add_error(changeset, :details, "cannot contain desired_rank and desired_amount")

      %{"desired_rank" => desired_rank, "start_rank" => start_rank} = details ->
        items = Repo.all(Variant.boost_price_query(id, start_rank, desired_rank))

        base_price =
          items
          |> Enum.reduce(0, fn item, acc -> Decimal.add(acc, item) end)
          |> Decimal.mult(100)
          |> Decimal.to_integer()

        put_change(changeset, :price, base_price)

      %{"start_rank" => start_rank, "desired_amount" => desired_amount} = details ->
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
          |> Decimal.mult(100)
          |> Decimal.to_integer()

        put_change(changeset, :price, base_price)

      true ->
        add_error(changeset, :details, "rank params cannot be null")
    end
  end

  def put_title(changeset) do
    details = get_field(changeset, :details)

    case Repo.one(Category.title_query(details["collection_id"])) do
      [category, collection] ->
        case Repo.all(Product.ranks_query(details["start_rank"], details["desired_rank"])) do
          [start, finish] ->
            title =
              format_title(
                "ranks",
                category,
                collection,
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
                start,
                details["desired_amount"]
              )

            put_change(changeset, :title, title)
        end

      _ ->
        add_error(changeset, :collection_id, "invalid collection_id")
    end
  end

  defp format_title(type, category, collection, start_rank, item) do
    case type do
      "ranks" ->
        category <> " | " <> collection <> " - " <> start_rank <> " to " <> item

      "games" ->
        category <> " | " <> Integer.to_string(item) <> " " <> collection <> " - " <> start_rank
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
