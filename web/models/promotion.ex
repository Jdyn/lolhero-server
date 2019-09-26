defmodule LolHero.Promotion do
  use LolHero.Web, :model

  alias LolHero.{}

  schema "promotions" do
    field(:title, :string)
    field(:description, :string)
    field(:is_valid, :boolean, default: true)
    field(:code, :string)

    field(:use_count, :integer)

    timestamps()
  end

  def changeset(promotion, attrs) do
    promotion
    |> cast(attrs, [:title, :description, :isValid, :code])
    |> validate_required([:title, :description, :code])
    |> unique_constraint(:title)
    |> unique_constraint(:code)
  end
end
