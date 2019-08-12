defmodule LolHero.Variant do
  use LolHero.Web, :model

  alias LolHero.{Repo, Product, Variant, Collection}

  schema "variants" do
    field(:title, :string)
    field(:description, :string)
    field(:base_price, :decimal)

    belongs_to(:product, Product)
    belongs_to(:collection, Collection)

    timestamps()
  end

  def create(attrs) do
    %Variant{}
    |> changeset(attrs)
    |> Repo.insert()
    |> Repo.preload(:product)
  end

  def update(%Variant{} = variant, attrs) do
    variant
    |> changeset(attrs)
    |> Repo.update()
  end

  def find(id) do
    Variant
    |> Repo.get(id)
    |> Repo.preload(:product)
  end

  def find_all() do
    Variant
    |> Repo.all()
    |> Repo.preload(:product)
  end

  def delete(%Variant{} = variant) do
    variant
    |> Repo.delete()
  end

  def find_by_assoc_titles(category_title, collection_title) do
    query =
      from(
        cc in Collection,
        left_join: c in assoc(cc, :category),
        where: c.title == ^category_title and cc.title == ^collection_title,
        preload: [:variants],
        select: cc
      )

    collection = Repo.one(query)

    Enum.reduce(collection.variants, %{}, fn item, prices ->
      Map.put(prices, item.title, item.base_price)
    end)
  end

  # def get_base_price(%{"collection_id" => id} = params) do
  #   query =
  #     from(v in Variant,
  #       where:
  #         v.collection_id == ^id and v.product_id >= ^params["start_rank"] and
  #           v.product_id < ^params["desired_rank"],
  #       select: v.base_price
  #     )

  #   items = Repo.all(Variant.boost_price_query)
  #   Enum.reduce(items, 0, fn item, acc -> Decimal.add(acc, item) end)
  # end

  def boost_price_query(id, start_rank, desired_rank) do
    from(v in Variant,
      where:
        v.collection_id == ^id and v.product_id >= ^start_rank and
          v.product_id < ^desired_rank,
      select: v.base_price
    )
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :base_price, :product_id, :collection_id])
    |> validate_required([:title, :description, :base_price, :product_id, :collection_id])
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:collection_id)
  end
end
