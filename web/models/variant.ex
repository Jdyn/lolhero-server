defmodule LolHero.Variant do
  use LolHero.Web, :model

  alias LolHero.{Repo, Product, Variant, Collection}

  schema "variants" do
    field(:title, :string)
    field(:description, :string)
    field(:base_price, :integer)

    belongs_to(:product, Product)
    belongs_to(:collection, Collection)

    timestamps()
  end

  def update(attrs, %Variant{} = variant) do
    variant
    |> Variant.changeset(attrs)
    |> Repo.update()
  end

  def create(attrs) do
    %Variant{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :base_price, :product_id, :collection_id])
    |> validate_required([:title, :description, :base_price, :product_id, :collection_id])
  end
end
