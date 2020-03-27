defmodule LolHero.UserController do
  use LolHero.Web, :controller

  alias LolHero.{User, ErrorView, Repo, UserView}
  alias LolHero.Services.Users

  def index(conn, _params) do
    render(conn, "index.json", users: User.find_all())
  end

  def show(conn, params) do
    query = String.to_atom(params["query"])

    user =
      User.find_by(%{query => params["id"]})
      |> Repo.preload(:orders)

    render(conn, "show.json", full_user: user)
  end

  def reset_password(conn, params) do
    Users.reset_password(params)

    conn
    |> put_status(:created)
    |> put_view(UserView)
    |> render("success.json", %{})
  end

  def update_password(conn, params) do
    case Users.update_password(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_view(UserView)
        |> render("success.json")

      {:unauthorized, reason} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)

      {:expired, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("error.json", error: reason)

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
        |> render("show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def update(conn, params) do
    query = String.to_atom(params["query"])

    user = User.find_by(%{query => params["id"]})

    user
    |> User.update(params)
    |> case do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("user.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def log_in(conn, _params) do
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

  def log_out(conn, _params) do
    Guardian.revoke(Guardian.Plug.current_token(conn))

    conn
    |> put_status(:ok)
    |> render("success.json")
  end

  def refresh_session(conn, _params) do
    case Sessions.refresh(Guardian.Plug.current_token(conn)) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("session_user.json", session_user: user)

      {:error, reason} ->
        conn
        |> put_status(:ok)
        |> put_view(ErrorView)
        |> render("changeset.json", error: reason)
    end
  end
end
