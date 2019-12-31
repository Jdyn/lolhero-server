defmodule LolHero.UserController do
  use LolHero.Web, :controller

  alias LolHero.{User, ErrorView, Repo, SessionView, UserView}
  alias LolHero.Services.Users

  def index(conn, _params) do
    render(conn, "index.json", users: User.find_all())
  end

  def show(conn, params) do
    render(conn, "show.json", user: User.find_by(id: params["id"]) |> Repo.preload(:orders))
  end

  def reset_password(conn, params) do
    Users.reset_password(params)

    conn
    |> put_status(:created)
    |> put_view(UserView)
    |> render("success.json", %{})

    # case Users.reset_password(params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_status(:created)
    #     |> put_view(UserView)
    #     |> render("show.json", user: user)

    #   {:error, reason} ->
    #     conn
    #     |> put_status(:unprocessable_entity)
    #     |> put_view(ErrorView)
    #     |> render("error.json", reason: reason)
    # end
  end

  def update_password(conn, params) do
    case Users.update_password(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_view(UserView)
        |> render("delete.json", user: user)

      {:unauthorized, reason} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("error.json", reason: reason)

      {:expired, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("error.json", reason: reason)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def create(conn, params) do
    case Users.create(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_view(SessionView)
        |> render("show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
