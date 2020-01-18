defmodule LolHero.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:avatar, :string)
      add(:username, :string)
      add(:last_name, :string)
      add(:first_name, :string)
      add(:role, :string, default: "user")
      add(:password_hash, :string)
      add(:is_admin, :boolean, default: false, null: false)
      add(:reset_token, :string)
      add(:reset_token_expiry, :utc_datetime)
      
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:username]))
  end
end
