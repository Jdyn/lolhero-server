defmodule LolHero.VariantView do
    use LolHero.Web, :view
  
    def render("index.json", %{session: session}) do
      %{}
    end
  
    def render("update.json", %{variant: variant}) do
      %{
        ok: true,
        result: %{
          variant: render_one(products, __MODULE__, "variant.json")
        }
      }
    end
  
    def render("variant.json", %{variant: variant}) do
      %{
        id: variant.id,
        title: variant.title,
        base_price: variant.base_price,
        rank: variant.product.id
      }
    end
  
    def render("created.json", %{}) do
      %{
        ok: true,
        result: %{}
      }
    end
  end
  