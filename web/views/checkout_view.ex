defmodule LolHero.CheckoutView do
  use LolHero.Web, :view

  def render("index.json", %{session: session}) do
    %{
      ok: true,
      result: %{
        session: %{
          id: session.id
        }
      }
    }
  end
end
