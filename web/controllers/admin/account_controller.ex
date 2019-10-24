defmodule LolHero.Admin.AccountController do
  use LolHero.Web, :controller

  alias LolHero.Services.Accounts
  alias LolHero.{ErrorView, AccountView}

  def orders(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.all_user_orders(user.id, user.is_admin) do
      {:ok, orders} ->
        conn
        |> put_status(:ok)
        |> put_view(AccountView)
        |> render("order_list.json", orders: orders)

      {:error, reason} ->
        conn
        |> put_status(:ok)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)
    end
  end
end
