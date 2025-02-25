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
      add(:email, :string)
      add(:note, :text)
      add(:is_editable, :boolean)
      add(:is_active, :boolean)
      add(:is_complete, :boolean)
      add(:transaction_id, :string)
      add(:user_id, references(:users))
      add(:booster_id, references(:users))

      add(:account_details, :map)

      timestamps()
    end
  end
end
