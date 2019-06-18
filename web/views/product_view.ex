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
    }
  end

  def render("created.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
