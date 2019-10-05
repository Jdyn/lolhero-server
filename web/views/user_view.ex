defmodule LolHero.UserView do
  use LolHero.Web, :view
  alias LolHero.{UserView}

  def render("index.json", %{users: users}) do
    %{
      ok: true,
      result: %{users: render_many(users, UserView, "user.json")}
    }
  end

  def render("create.json", %{user: user}) do
    %{
      ok: true,
      result: %{
        user: render_one(user, UserView, "user.json")
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

  def render("jwt.json", %{jwt: token}) do
    %{
      ok: true,
      result: %{
        user: %{
          token: token
        }
      }
    }
  end

  def render("delete.json", _) do
    %{
      ok: true,
      result: %{}
    }
  end

  def render("order_user.json", %{user: user}) do
    %{
      username: user.username,
      role: user.role,
      isAdmin: user.is_admin
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      username: user.username,
      is_admin: user.is_admin,
      email: user.email,
      role: user.role
      # orders: render_many(user.orders, OrderView, "order.json", as: :order)
    }
  end
end
