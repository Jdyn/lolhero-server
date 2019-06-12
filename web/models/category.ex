defmodule LolHero.Category do
  use LolHero.Web, :model

  alias LolHero.{Category, Variant}

  schema "categories" do
    field(:title, :string) # IE: solo-boost / duo-boost
    field(:description, :string)

    has_many(:products, Variant)
  end

  def create(attrs) do
    %Category{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
