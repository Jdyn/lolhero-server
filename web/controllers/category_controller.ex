defmodule LolHero.CategoryController do
  use LolHero.Web, :controller

  alias LolHero.{Category, Collection}

  def index(conn, _params) do
    render(conn, "list.json", categories: Category.find_all())
  end

  def prices(conn, _params) do
    render(conn, "prices.json", categories: Category.format_prices(Category.find_all()))
  end

  def create(conn, params) do
    params
    |> Category.create()
    |> case do
      {:ok, _category} ->
        conn
        |> put_status(:created)
        |> render("created.json")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    id
    |> Category.find()
    |> Category.update(params)
    |> case do
      {:ok, category} ->
        conn
        |> put_status(:ok)
        |> render("update.json", category: category)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
