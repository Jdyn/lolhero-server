defmodule LolHero.OrderController do
  use LolHero.Web, :controller
  import Ecto

  alias LolHero.Order

  def index(conn, params), do: render(conn, "index.json", orders: Order.find_all())

  def show(conn, params) do
    case Order.find_by(tracking_id: params["id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(LolHero.ErrorView)
        |> render("error.json", error: "Order does not exist.")

      order ->
        render(conn, "show.json", order: order)
    end
  end

  def create(conn, params) do
    tracking_id = Ecto.UUID.generate() |> binary_part(16, 16)

    params
    |> Map.put("tracking_id", to_string(tracking_id))
    |> Order.create()
    |> case do
      {:ok, order} ->
        %{tracking_id: tracking_id, title: title, price: price} = order
        
        

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
