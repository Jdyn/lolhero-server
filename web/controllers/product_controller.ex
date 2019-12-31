defmodule LolHero.ProductController do
  use LolHero.Web, :controller

  alias LolHero.Product

  def index(conn, _params) do
    render(conn, "index.json", products: Product.find_all())
  end

  def show(conn, params) do
    render(conn, "show.json", product: Product.find(params["id"]))
  end

  def create(conn, params) do
    params
    |> Product.create()
    |> case do
      {:ok, _product} ->
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
    |> Product.find()
    |> Product.update(params)
    |> case do
      {:ok, product} ->
        conn
        |> put_status(:ok)
        |> render("show.json", product: product)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def delete(conn, params) do
    case Product.find(params["id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(LolHero.ErrorView)
        |> render("error.json", error: "Product does not exist.")

      product ->
        Product.delete(product)
        |> case do
          {:ok, _product} ->
            conn
            |> put_status(:ok)
            |> render("ok.json")

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> put_view(LolHero.ErrorView)
            |> render("changeset_error.json", changeset: changeset)
        end
    end
  end
end
