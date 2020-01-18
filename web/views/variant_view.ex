defmodule LolHero.VariantView do
  use LolHero.Web, :view

  def render("index.json", %{variants: variants}) do
    %{
      ok: true,
      result: %{
        variants: render_many(variants, __MODULE__, "variant.json")
      }
    }
  end

  def render("show.json", %{variant: variant}) do
    %{
      ok: true,
      result: %{
        variant: render_one(variant, __MODULE__, "variant.json")
      }
    }
  end

  def render("update.json", %{variant: variant}) do
    %{
      ok: true,
      result: %{
        variant: render_one(variant, __MODULE__, "variant.json")
      }
    }
  end

  def render("variant.json", %{variant: variant}) do
    %{
      id: variant.id,
      title: variant.title,
      base_price: variant.base_price,
      product_id: variant.product.id,
      collection_id: variant.collection_id,
      collection_name: variant.collection.title
    }
  end

  def render("ranks.json", %{variant: variant}) do
    %{
      id: variant.id,
      title: variant.title,
      base_price: variant.base_price,
      rank: variant.product.id
    }
  end

  def render("ok.json", _) do
    %{
      ok: true,
      result: %{}
    }
  end
end
