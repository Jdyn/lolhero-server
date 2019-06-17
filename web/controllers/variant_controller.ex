defmodule LolHero.VariantController do
  use LolHero.Web, :controller

  alias LolHero.{Repo, Product, Variant}

  def create(conn, params) do
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

  def update(conn, params) do
    params
    |> Variant.update(Repo.get(Variant, params["id"]))
    |> case do
      {:ok, variant} ->
        conn
        |> put_status(:ok)
        |> render("variant.json", variant: variant |> Repo.preload(:product))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
