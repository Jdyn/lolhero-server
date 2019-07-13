defmodule LolHero.Category do
  use LolHero.Web, :model

  alias LolHero.{Repo, Category, Collection}

  schema "categories" do
    field(:title, :string)
    field(:description, :string)

    has_many(:collections, Collection)

    timestamps()
  end

  def create(attrs) do
    %Category{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(%Category{} = category, attrs) do
    category
    |> changeset(attrs)
    |> Repo.update()
  end

  def find(id) do
    Category
    |> Repo.get(id)
  end

  def find_all() do
    Category
    |> Repo.all()
    |> Repo.preload(collections: [variants: [:product]])
  end

  def format_prices(categories) do
    Enum.reduce(categories, %{}, fn category, prices ->
      Map.put(
        prices,
        category.title,
        Enum.reduce(category.collections, %{}, fn collection, prices ->
          cond do
            collection.id == 10 or collection.id == 9 or collection.id == 11 or
                collection.id == 12 or collection.id == 13 ->
              Map.put(
                prices,
                collection.title,
                Enum.reduce(collection.variants, %{}, fn item, prices ->
                  prices
                  |> Map.put(item.title, Decimal.to_float(item.base_price))
                end)
              )

            true ->
              Map.put(
                prices,
                collection.id,
                Enum.reduce(collection.variants, %{}, fn item, prices ->
                  prices
                  |> Map.put(item.product_id, Decimal.to_float(item.base_price))
                end)
              )
          end
        end)
      )
    end)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end

  def title_query(id) do
    from(cc in Collection,
      where: cc.id == ^id,
      join: c in Category,
      on: [id: cc.category_id],
      select: [c.title, cc.title]
    )
  end
end
