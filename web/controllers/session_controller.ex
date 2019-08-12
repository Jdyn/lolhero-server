defmodule LolHero.SessionController do
  use LolHero.Web, :controller

  alias LolHero.ErrorView
  alias LolHero.Services.Sessions
  alias LolHero.Auth.Guardian

  def show(conn, params) do
    case Sessions.refresh(Guardian.Plug.current_token(conn)) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("show.json", user: user)

      {:error, reason} ->
        conn
        |> put_status(:ok)
        |> put_view(ErrorView)
        |> render("changeset.json", error: reason)
    end
  end

  def create(conn, params) do
    case Sessions.authenticate(params) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("create.json", user: user)

      {:error, reason} ->
        conn
        |> put_status(:ok)
        |> put_view(ErrorView)
        |> render("error.json", %{error: reason})
    end
  end

  def delete(conn, params) do
    Guardian.revoke(Guardian.Plug.current_token(conn))

    conn
    |> put_status(:ok)
    |> render("delete.json")
  end
end
