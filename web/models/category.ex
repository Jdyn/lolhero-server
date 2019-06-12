defmodule LolHero.Category do
  use LolHero.Web, :model

  alias LolHero.{Repo, Category, Collection}

  schema "categories" do
    field(:title, :string) # IE: solo-boost / duo-boost
    field(:description, :string)
 
    has_many(:collections, Collection)

    timestamps()
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
