defmodule LolHero.UserController do
  use LolHero.Web, :controller

  alias LolHero.{User, ErrorView, Repo}
  alias LolHero.Services.Users

  def index(conn, _params) do
    render(conn, "index.json", users: User.find_all())
  end

  def show(conn, params) do
    render(conn, "show.json", user: User.find_by(id: params["id"]) |> Repo.preload(:orders))
  end

  def create(conn, params) do
    case Users.create(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("create.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
