defmodule LolHero.PriceController do
  use LolHero.Web, :controller

  alias LolHero.{Product, Collection, Category}

  def index(conn, params) do
  end

  def latest(conn, params) do
    categories = Repo.all(Category) |> Repo.preload(collections: [:variants])

    conn
    |> put_status(:ok)
    |> put_view(LolHero.PriceView)
    |> render("latest.json", categories: categories)
  end
end
