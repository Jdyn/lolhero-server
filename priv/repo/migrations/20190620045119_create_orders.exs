defmodule LolHero.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:type, :string)
      add(:tracking_id, :string)
      add(:is_express, :boolean)
      add(:details, :map)

      timestamps()
    end
  end
end
