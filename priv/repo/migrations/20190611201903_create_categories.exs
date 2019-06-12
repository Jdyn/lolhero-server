defmodule LolHero.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:title, :string)
      add(:description, :text)

      timestamps()
    end
  end
end
