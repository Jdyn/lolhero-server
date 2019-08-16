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

  def render("show.json", %{user: user}) do
    %{
      ok: true,
      result: %{
        user: render_one(user, SessionView, "user.json", as: :user)
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
      username: user.username,
      email: user.email,
      token: user.token
    }
  end
end
