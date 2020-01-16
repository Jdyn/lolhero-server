defmodule LolHero.CategoryController do
  use LolHero.Web, :controller

  alias LolHero.{Category, ErrorView}
  alias LolHero.Services.Categories

  def index(conn, _params) do
    render(conn, "list.json", categories: Category.find_all())
  end

  def show(conn, params) do
    render(conn, "show.json", category: Category.find_by(id: params["id"]))
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
    Category.find(id)
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

  def delete(conn, %{"id" => id}) do
    case Categories.delete(id) do
      {:ok, _category} ->
        conn
        |> put_status(:ok)
        |> render("delete.json")

      {:not_found, error} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("error.json", error: error)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
