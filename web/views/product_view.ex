defmodule LolHero.ProductView do
  use LolHero.Web, :view

  def render("index.json", %{session: session}) do
    %{}
  end

  def render("list_products.json", %{products: products}) do
    %{
      ok: true,
      result: %{
        products: render_many(products, __MODULE__, "product.json")
      }
    }
  end

  def render("variant.json", %{variant: variant}) do
    %{
      id: variant.id,
      title: variant.title,
      base_price: variant.base_price
    }
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      title: product.title,
    }
  end

  def render("created.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
