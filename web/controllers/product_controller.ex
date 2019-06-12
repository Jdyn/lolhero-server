defmodule LolHero.ProductController do
  use LolHero.Web, :controller

  alias LolHero.{Product, Variant}

  def create_product(conn, params) do
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

  def create_variant(conn, params) do
    params
    |> Variant.create()
    |> case do
      {:ok, variant} ->
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
