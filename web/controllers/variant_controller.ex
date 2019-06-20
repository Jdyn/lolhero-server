defmodule LolHero.VariantController do
  use LolHero.Web, :controller

  alias LolHero.Variant

  def index(conn, _params) do
    render(conn, "index.json", variants: Variant.find_all())
  end

  def show(conn, params) do
    render(conn, "show.json", variant: Variant.find(params["id"]))
  end

  def create(conn, params) do
    params
    |> Variant.create()
    |> case do
      {:ok, _variant} ->
        conn
        |> put_status(:created)
        |> render("ok.json")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def update(conn, params) do
    variant = Variant.find(params["id"])

    variant
    |> Variant.update(params)
    |> case do
      {:ok, variant} ->
        conn
        |> put_status(:ok)
        |> render("variant.json", variant: variant)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def delete(conn, params) do
    case Variant.find(params["id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(LolHero.ErrorView)
        |> render("error.json", %{error: "Snippet does not exist."})

      variant ->
        Variant.delete(variant)
        |> case do
          {:ok, _variant} ->
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
