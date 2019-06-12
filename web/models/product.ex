defmodule LolHero.Product do
	use LolHero.Web, :model
	
	alias LolHero.{Repo, Product, Variant}

  schema "products" do
    field(:title, :string)
    field(:description, :string)

    has_many(:variants, Variant)

    timestamps()
  end

  def create(attrs) do
    %Product{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
