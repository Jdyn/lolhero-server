defmodule LolHero.OrderController do
  use LolHero.Web, :controller
  import Ecto

  alias LolHero.Order

  def index(conn, params) do
    render(conn, "index.json", orders: Order.find_all())
  end

  def create(conn, params) do
    tracking_id = Ecto.UUID.generate() |> binary_part(16, 16)

    params
    |> Map.put("tracking_id", to_string(tracking_id))
    |> Order.create()
    |> case do
      {:ok, _order} ->
        conn
        |> put_status(:created)
        |> put_view(LolHero.ProductView)
        |> render("created.json")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
