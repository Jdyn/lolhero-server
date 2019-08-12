defmodule LolHero.AccountController do
  use LolHero.Web, :controller

  alias LolHero.Services.Accounts

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
        |> put_view(LolHero.ErrorView)
        |> render("error.json", error: reason)
    end
  end
end
