defmodule LolHero.ProductView do
  use LolHero.Web, :view

  def render("index.json", %{session: session}) do
    %{}
  end

  def render("variant.json", %{variant: variant}) do
    %{
      id: variant.id,
      title: variant.title,
      base_price: variant.base_price
    }
  end

  def render("created.json", %{}) do
    %{
      ok: true,
      result: %{}
    }
  end
end
