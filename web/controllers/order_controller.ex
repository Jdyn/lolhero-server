defmodule LolHero.OrderController do
  use LolHero.Web, :controller
  import Ecto
  alias LolHero.{Order, ErrorView}
  alias Braintree.ClientToken

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

  def create_token(conn, params) do
    {:ok, token} = ClientToken.generate(%{version: 3})

    render(conn, "token.json", token: token)
  end

  def create(conn, params) do
    tracking_id = Ecto.UUID.generate() |> binary_part(10, 10)

    case user = Guardian.Plug.current_resource(conn) do
      nil ->
        params
        |> Map.put("tracking_id", to_string(tracking_id))
        |> Order.create()
        |> case do
          {:ok, order} ->
            %{tracking_id: tracking_id} = order

            success_url = "/order/success/#{tracking_id}/"

            conn
            |> put_status(:ok)
            |> render("created.json", %{order: order, success_url: success_url})

          {:error, changeset} ->
            conn
            |> put_status(:ok)
            |> put_view(ErrorView)
            |> render("changeset_error.json", changeset: changeset)
        end

      user ->
        params
        |> Map.put("tracking_id", to_string(tracking_id))
        |> Map.put("user_id", user.id)
        |> Order.create()
        |> case do
          {:ok, order} ->
            %{tracking_id: tracking_id} = order

            success_url = "/order/success/#{tracking_id}/"

            conn
            |> put_status(:ok)
            |> render("created.json", %{order: order, success_url: success_url})

          {:error, changeset} ->
            conn
            |> put_status(:ok)
            |> put_view(ErrorView)
            |> render("changeset_error.json", changeset: changeset)
        end
    end
  end
end
