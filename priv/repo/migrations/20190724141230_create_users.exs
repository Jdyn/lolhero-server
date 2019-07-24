defmodule LolHero.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:username, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:age, :integer)
      add(:avatar, :string)

      add(:password_hash, :string)

      add(:is_admin, :boolean, default: false, null: false)
      
      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:username]))
  end
end
