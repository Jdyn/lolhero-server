defmodule LolHero.Repo.Migrations.AlterVariants do
  use Ecto.Migration

  def change do
    alter table("variants") do
      modify(:base_price, :decimal, from: :integer)
    end
  end
end
