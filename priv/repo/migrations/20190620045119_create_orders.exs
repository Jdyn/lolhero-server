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
      add(:transaction_id, :string)
      add(:user_id, references(:users))
      
      timestamps()
    end
  end
end
