defmodule LolHero.PriceView do
  use LolHero.Web, :view

  def render("latest.json", %{categories: categories}) do
    {:ok, solo} = Enum.fetch(categories, 0)
    {:ok, duo} = Enum.fetch(categories, 1)
    IO.inspect(solo.collections)
    %{
      ok: true,
      result: %{
        solo: %{
          boosts: render_many(solo.collections, LolHero.CollectionView, "collection.json", as: :collection)
        },
        duo: %{
          # boosts: render_many(duo, LolHero.CategoryView, "list.json", as: :category)
        }
      }
    }
  end
end
