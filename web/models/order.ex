defmodule LolHero.Order do
  use LolHero.Web, :model

  schema "orders" do
    field(:tracking_id, :integer)
    field(:server, :string)

    field(:queue, :string) # EX: soloq, duoq
    field(:service, :string) # EX: Division Boost, Net Wins // - "product_collection"
    field(:type, :string) # EX: Solo boost or Duo Boost // - "product_category"

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
