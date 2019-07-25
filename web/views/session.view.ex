defmodule LolHero.SessionView do
  use LolHero.Web, :view
  alias LolHero.{SessionView, User}

  def render("create.json", %{user: user}) do
    %{
      ok: true,
      result: %{
        user: render_one(user, SessionView, "user.json", as: :user)
      }
    }
  end

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

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      token: user.token
    }
  end
end
