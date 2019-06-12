defmodule LolHero.Repo.Migrations.CreateCollections do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add(:title, :string)
      add(:description, :text)

      add(:category_id, references(:categories))

      timestamps()
    end
  end
end