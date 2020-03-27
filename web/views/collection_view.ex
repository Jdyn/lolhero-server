defmodule LolHero.CollectionView do
  use LolHero.Web, :view

  def render("index.json", %{collections: collections}) do
    %{
      ok: true,
      result: %{
        collections: render_many(collections, __MODULE__, "collection.json")
      }
    }
  end

  def render("show.json", %{collection: collection}) do
    %{
      ok: true,
      result: %{
        collection: render_one(collection, __MODULE__, "collection.json")
      }
    }
  end

  def render("update.json", %{collection: collection}) do
    %{
      ok: true,
      result: %{
        collection: render_one(collection, __MODULE__, "collection.json")
      }
    }
  end

  def render("collection.json", %{collection: collection}) do
    %{
      id: collection.id,
      title: collection.title,
      description: collection.description,
      # items: render_many(collection.variants, LolHero.VariantView, "variant.json")
    }
  end

  def render("sucess.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
