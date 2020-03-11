defmodule LolHero.UserController do
  use LolHero.Web, :controller

  alias LolHero.{User, ErrorView, Repo, SessionView, UserView}
  alias LolHero.Services.Users

  def index(conn, _params) do
    render(conn, "index.json", users: User.find_all())
  end

  def show(conn, params) do
    query = String.to_atom(params["query"])

    user =
      User.find_by(%{query => params["id"]})
      |> Repo.preload(:orders)

    render(conn, "full_show.json", user: user)
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
    #     |> render("error.json", error: reason)
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

  def show_boosters(conn, _params) do
    boosters =
    Repo.all(
      from(user in User,
        where: user.role == "admin" or user.role == "booster",
        select: user
      )
    )

    conn
    |> put_status(:created)
    |> put_view(UserView)
    |> render("show_boosters.json", boosters: boosters)
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
end
