defmodule LolHero.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:is_available, :boolean)
    end
  end
end
