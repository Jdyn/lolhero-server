defmodule LolHero.UserView do
  use LolHero.Web, :view
  alias LolHero.{UserView, OrderView}

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

  def render("show_boosters.json", %{boosters: boosters}) do
    %{
      ok: true,
      result: %{boosters: render_many(boosters, UserView, "list_user.json")}
    }
  end

  def render("full_show.json", %{user: user}) do
    %{
      ok: true,
      result: %{
        user: render_one(user, UserView, "full_user.json")
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
      # firstName: user.first_name,
      # lastName: user.last_name,
      username: user.username,
      is_admin: user.is_admin,
      email: user.email,
      role: user.role
    }
  end

  def render("list_user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username
    }
  end

  def render("full_user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      is_admin: user.is_admin,
      email: user.email,
      role: user.role,
      orders: render_many(user.orders, OrderView, "order.json", as: :order)
    }
  end
end
