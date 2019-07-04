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

  def calculate_price(params) do
    query =
      from(v in Variant,
        where:
          v.collection_id == ^params["collection_id"] and v.product_id >= ^params["starting_rank"] and
            v.product_id <= ^params["desired_rank"],
        select: %{base_price: v.base_price}
      )

    items = Repo.all(query)
    Enum.reduce(items, 0, fn item, acc -> item.base_price + acc end)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :base_price, :product_id, :collection_id])
    |> validate_required([:title, :description, :base_price, :product_id, :collection_id])
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:collection_id)
  end
end
