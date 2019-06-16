defmodule LolHero.CollectionView do
  use LolHero.Web, :view

  def render("list.json", %{collections: collections}) do
    %{
      ok: true,
      result: %{
        collections: render_many(collections, __MODULE__, "collection.json")
      }
    }
  end

  def render("collection.json", %{collection: collection}) do
    %{
      # id: collection.id,
      title: collection.title,
      description: collection.description,
      items: render_many(collection.variants, LolHero.ProductView, "variant.json", as: :variant)
    }
  end

  def render("created.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
