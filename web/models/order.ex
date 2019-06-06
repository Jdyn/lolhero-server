defmodule LolHero.Order do
  use LolHero.Web, :model

  schema "orders" do
    field(:tracking_id, :integer)
    field(:queue, :string)
    field(:service, :string)
    field(:type, :string)
    field(:server, :string)

    field(:champions, {:array, :string})

    field(:starting_rank, :integer)
    field(:starting_lp, :integer)
    field(:starting_promos, :boolean)

    field(:desired_games, :integer)
    field(:desired_rank, :integer)
    field(:desired_wins, :integer)

    timestamps()
  end
end
