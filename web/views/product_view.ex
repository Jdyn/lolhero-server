defmodule LolHero.ProductView do
  use LolHero.Web, :view

  def render("index.json", %{products: products}) do
    %{
      ok: true,
      result: %{
        products: render_many(products, __MODULE__, "product.json")
      }
    }
  end

  def render("show.json", %{product: product}) do
    %{
      ok: true,
      result: %{
        product: render_one(product, __MODULE__, "product.json")
      }
    }
  end

  def render("list.json", %{products: products}) do
    %{
      ok: true,
      result: %{
        products: render_many(products, __MODULE__, "product.json")
      }
    }
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      title: product.title,
      variants: render_many(product.variants, __MODULE__, "variant.json", as: :variant)
    }
  end

  def render("variant.json", %{variant: variant}) do
    %{
      id: variant.id,
      title: variant.title,
      base_price: variant.base_price,
      product_id: variant.product_id,
      collection_id: variant.collection_id
    }
  end

  def render("created.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
