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

  def update(%Product{} = product, attrs) do
    product
    |> changeset(attrs)
    |> Repo.update()
  end

  def find(id) do
    Product
    |> Repo.get(id)
  end

  def find_all() do
    Product
    |> Repo.all()
  end

  def delete(%Product{} = product) do
    product
    |> Repo.delete()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> unique_constraint(:title)
  end

  def ranks_query(start_id, end_id) do
    from(
      p in Product,
      where: p.id == ^start_id or p.id == ^end_id,
      select: p.title,
      order_by: [asc: p.id]
    )
  end
end
