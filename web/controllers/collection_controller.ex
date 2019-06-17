defmodule LolHero.CollectionController do
  use LolHero.Web, :controller

  alias LolHero.{Product, Collection}

  def index(conn, params) do
  end

  def list(conn, params) do
    collections = Repo.all(Collection) |> Repo.preload(variants: [:product])
    render(conn, "list.json", collections: collections)
  end

  def create(conn, params) do
    params
    |> Collection.create()
    |> case do
      {:ok, collection} ->
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
