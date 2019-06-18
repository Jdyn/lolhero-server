defmodule LolHero.CollectionController do
  use LolHero.Web, :controller

  alias LolHero.Collection

  def index(conn, _params) do
    render(conn, "index.json", collections: Collection.find_all())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", collection: Collection.find(id))
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

  def update(conn, %{"id" => id}) do
    id
    |> Collection.find()
    |> Collection.update()
    |> case do
      {:ok, collection} ->
        conn
        |> put_status(:ok)
        |> render("collection.json", collection: collection)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
