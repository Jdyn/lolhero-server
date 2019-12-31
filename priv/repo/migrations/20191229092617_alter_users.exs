defmodule LolHero.Repo.Migrations.AlterVariants do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:reset_token, :string)
      add(:reset_token_expiry, :utc_datetime)
    end
  end
end
