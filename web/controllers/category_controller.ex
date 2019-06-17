defmodule LolHero.CategoryController do
  use LolHero.Web, :controller

  alias LolHero.{Product, Category}

  def list(conn, params) do
    categories = Repo.all(Category) |> Repo.preload(collections: [variants: [:product]])

    Enum.reduce(categories, %{}, fn data, acc ->
      Map.put(acc, String.to_atom(data.title), %{boosts: data.collections})
    end)

    render(conn, "list.json", categories: categories)
  end

  def create(conn, params) do
    params
    |> Category.create()
    |> case do
      {:ok, category} ->
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
end
