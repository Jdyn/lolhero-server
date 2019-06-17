defmodule LolHero.ProductController do
  use LolHero.Web, :controller

  alias LolHero.{Product, Variant}

  def create(conn, params) do
    params
    |> Product.create()
    |> case do
      {:ok, product} ->
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

  def list(conn, _params) do
    render(conn, "list_products.json", products: Repo.all(Product))
  end
end
