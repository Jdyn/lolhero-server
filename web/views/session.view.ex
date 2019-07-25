defmodule LolHero.SessionView do
  use LolHero.Web, :view
  alias LolHero.SessionView

  def render("show.json", %{token: token}) do
    %{
      ok: true,
      result: %{
        token: token
      }
    }
  end

  def render("delete.json", _) do
    %{
      ok: true,
      result: %{}
    }
  end
end
