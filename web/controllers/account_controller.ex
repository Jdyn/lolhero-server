defmodule LolHero.AccountController do
  use LolHero.Web, :controller

  alias LolHero.Services.Accounts
  alias LolHero.ErrorView

  def orders(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.all_orders(user.id) do
      {:ok, orders} ->
        IO.inspect(orders)

        conn
        |> put_status(:ok)
        |> render("order_list.json", orders: orders)

      {:error, reason} ->
        conn
        |> put_status(:ok)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)
    end
  end

  def show_order(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    case(Accounts.show_order(user.id, params["tracking_id"])) do
      {:ok, order} ->
        conn
        |> put_status(:ok)
        |> render("show_order.json", order: order)

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)
    end
  end
end
