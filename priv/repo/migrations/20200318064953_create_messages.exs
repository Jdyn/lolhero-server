defmodule LolHero.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add(:message, :text)

      add(:user_id, references(:users))
      add(:order_id, references(:orders))

      timestamps()
    end
  end
end
