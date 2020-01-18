defmodule LolHero.Repo.Migrations.CreateVariants do
  use Ecto.Migration

  def change do
    create table(:variants) do
      add(:title, :string)
      add(:description, :text)
      add(:base_price, :decimal)

      add(:product_id, references(:products))
      add(:collection_id, references(:collections))

      timestamps()
    end
  end
end

