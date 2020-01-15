defmodule LolHero.OrderView do
  use LolHero.Web, :view

  alias LolHero.{UserView, OrderView}

  def render("index.json", %{orders: orders}) do
    %{
      ok: true,
      result: %{
        orders: render_many(orders, OrderView, "order.json")
      }
    }
  end

  def render("token.json", %{token: token}) do
    %{
      ok: true,
      result: %{
        token: token
      }
    }
  end

  def render("show.json", %{order: order}) do
    %{
      ok: true,
      result: %{
        order: render_one(order, OrderView, "full_order.json")
      }
    }
  end

  def render("session.json", %{session: session}) do
    %{
      ok: true,
      result: %{
        session: %{
          id: session.id
        }
      }
    }
  end

  def render("created.json", %{order: order, success_url: success_url}) do
    %{
      ok: true,
      result: %{
        success_url: success_url,
        order: render_one(order, OrderView, "order.json")
      }
    }
  end

  def render("order.json", %{order: order}) do
    %{
      title: order.title,
      status: order.status,
      trackingId: order.tracking_id,
      createdAt: order.inserted_at,
      id: order.id,
      price: order.price
    }
  end

  def render("full_order.json", %{order: order}) do
    %{
      title: order.title,
      status: order.status,
      note: order.note,
      trackingId: order.tracking_id,
      createdAt: order.inserted_at,
      isEditable: order.is_editable,
      price: order.price,
      user: render_one(order.user, UserView, "order_user.json", as: :user),
      booster: render_one(order.booster, UserView, "order_user.json", as: :user),
      details: order.details
    }
  end

  def render("full_booster_order.json", %{order: order}) do
    %{
      title: order.title,
      status: order.status,
      note: order.note,
      trackingId: order.tracking_id,
      createdAt: order.inserted_at,
      isEditable: order.is_editable,
      price: order.price,
      user: render_one(order.user, UserView, "order_user.json", as: :user),
      booster: render_one(order.booster, UserView, "order_user.json", as: :user),
      details: order.details,
      accountDetails: order.account_details
    }
  end
end
