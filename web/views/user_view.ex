defmodule LolHero.UserView do
  use LolHero.Web, :view
  alias LolHero.{UserView, OrderView}

  def render("index.json", %{users: users}) do
    %{
      ok: true,
      result: %{
        users: render_many(users, UserView, "user.json")
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{
      ok: true,
      result: %{
        user: render_one(user, UserView, "user.json")
      }
    }
  end

  def render("show.json", %{full_user: full_user}) do
    %{
      ok: true,
      result: %{
        user: render_one(full_user, UserView, "full_user.json")
      }
    }
  end

  def render("show.json", %{session_user: session_user}) do
    %{
      ok: true,
      result: %{
        user: render_one(session_user, UserView, "session_user.json")
      }
    }
  end

  def render("success.json", _) do
    %{
      ok: true,
      result: %{}
    }
  end

  def render("order_user.json", %{user: user}) do
    %{
      username: user.username,
      role: user.role
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role
    }
  end

  def render("session_user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email,
      token: user.token,
      isAdmin: user.is_admin,
      role: user.role,
      id: user.id
    }
  end

  def render("full_user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email,
      isAdmin: user.is_admin,
      role: user.role,
      id: user.id,
      orders: render_many(user.orders, OrderView, "order.json", as: :order)
    }
  end
end
