defmodule LolHero.AccountController do
  use LolHero.Web, :controller

  alias LolHero.Services.{Accounts, User}
  alias LolHero.{ErrorView}

  def orders(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.all_user_orders(user.id, user.role) do
      {:ok, orders} ->
        case user.role do
          match when match in ["booster", "admin"] ->
            conn
            |> put_status(:ok)
            |> render("booster_order_list.json", orders: orders)

          "user" ->
            conn
            |> put_status(:ok)
            |> render("order_list.json", orders: orders)
        end

      {:error, reason} ->
        conn
        |> put_status(:ok)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)
    end
  end

  def initiate(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.initiate(params, user) do
      {:ok, order} ->
        conn
        |> put_status(:ok)
        |> render("show_order.json", order: order)

      {:unauthorized, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def show_order(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    case(Accounts.show_order(user.id, user.role, params["tracking_id"])) do
      {:ok, order} ->
        case user.role do
          match when match in ["booster", "admin"] ->
            conn
            |> put_status(:ok)
            |> render("show_booster_order.json", order: order)

          "user" ->
            conn
            |> put_status(:ok)
            |> render("show_order.json", order: order)
        end

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)
    end
  end

  def change_status(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.change_status(user.id, params["tracking_id"], params["status"]) do
      {:ok, order} ->
        conn
        |> put_status(:ok)
        |> render("show_order.json", order: order)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
