defmodule LolHero.CategoryView do
  use LolHero.Web, :view

  def render("prices.json", %{categories: categories}) do
    %{
      ok: true,
      result: categories
    }
  end

  def render("list.json", %{categories: categories}) do
    %{
      ok: true,
      result: %{
        categories: render_many(categories, __MODULE__, "category.json")
      }
    }
  end

  def render("update.json", %{category: category}) do
    %{
      ok: true,
      result: %{
        category: render_one(category, __MODULE__, "base.json")
      }
    }
  end

  def render("base.json", %{category: category}) do
    %{
      id: category.id,
      title: category.title,
    }
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
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
