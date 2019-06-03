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

  def render("error.json", %{error: error}) do
    %{
      ok: false,
      result: %{}
    }
  end
end
