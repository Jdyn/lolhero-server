defmodule LolHero.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:type, :string)
      add(:title, :string)
      add(:price, :decimal)
      add(:status, :string)
      add(:paid, :boolean)
      add(:tracking_id, :string)
      add(:details, :map)
      add(:note, :text)
      
      timestamps()
    end
  end
end
