defmodule LolHero.Order do
  use LolHero.Web, :model

  alias LolHero.{Repo, Order}

  schema "orders" do
    field(:type, :string)
    field(:tracking_id, :string)
    field(:is_express, :boolean)
    field(:details, :map)

    # field(:server, :string)
    # field(:queue, :string)
    # field(:service, :string)
    # field(:champions, {:array, :string})

    # field(:starting_rank, :integer)
    # field(:starting_lp, :integer)
    # field(:starting_promos, :boolean)

    # field(:desired_games, :integer)
    # field(:desired_rank, :integer)
    # field(:desired_wins, :integer)

    timestamps()
  end

  def create(attrs) do
    %Order{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def find_all() do
    Order
    |> Repo.all()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:type, :details, :tracking_id, :is_express])
    |> validate_required([:type, :details, :tracking_id, :is_express])
    |> validate_keys(:details, ["starting_rank", "starting_lp", "server", "queue"])
  end

  def validate_keys(changeset, field, required_keys \\ []) do
    details = get_field(changeset, field)

    Enum.reduce(required_keys, changeset, fn key, changeset ->
      if Map.has_key?(details, key) do
        changeset
      else
        add_error(changeset, field, "Key: \"#{key}\" must exist in details.")
      end
    end)
  end
end
