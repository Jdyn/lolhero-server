defmodule LolHero.CategoryController do
  use LolHero.Web, :controller

  alias LolHero.{Product, Category}

  def list(conn, params) do
    categories = Repo.all(Category) |> Repo.preload(collections: [variants: [:product]])

    render(conn, "list.json", categories: categories)
  end

  def prices(conn, params) do
    categories = Repo.all(Category) |> Repo.preload(collections: [variants: [:product]])

    solo = Enum.at(categories, 0)
    duo = Enum.at(categories, 1)

    render(conn, "prices.json",
      categories: %{
        solo: format_collections(solo.collections),
        duo: format_collections(duo.collections)
      }
    )
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

  defp format_collections(collections) do
    Enum.reduce(collections, %{}, fn data, acc ->
      Map.put(
        acc,
        String.to_atom(data.title),
        Enum.reduce(data.variants, %{}, fn item, acc ->
          Map.put(acc, item.product_id, item.base_price)
        end)
      )
    end)
  end
end
