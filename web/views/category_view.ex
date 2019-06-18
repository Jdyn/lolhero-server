defmodule LolHero.CategoryView do
  use LolHero.Web, :view

  def render("prices.json", %{categories: categories}) do
    %{
      ok: true,
      result: %{
        solo: categories.solo,
        duo: categories.duo
      }
    }
  end

  def render("list.json", %{categories: categories}) do
    %{
      ok: true,
      result: render_many(categories, __MODULE__, "category.json")
    }
  end

  def render("category.json", %{category: category}) do
    %{
      # id: category.id,
      title: category.title,
      collections: render_many(category.collections, LolHero.CollectionView, "collection.json")
    }
  end

  def render("created.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
