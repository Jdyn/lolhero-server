defmodule LolHero.Collection do
  use LolHero.Web, :model

  alias LolHero.{Repo, Collection, Category, Variant}

  schema "collections" do
    field(:title, :string)
    field(:description, :string)

    has_many(:variants, Variant)
    belongs_to(:category, Category)

    timestamps()
  end

  def create(attrs) do
    %Collection{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :category_id])
    |> validate_required([:title, :description, :category_id])
    |> foreign_key_constraint(:category_id)
  end
end
