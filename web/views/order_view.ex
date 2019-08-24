defmodule LolHero.OrderView do
  use LolHero.Web, :view

  def render("index.json", %{orders: orders}) do
    %{
      ok: true,
      result: %{
        orders: render_many(orders, __MODULE__, "order.json")
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
        order: render_one(order, __MODULE__, "full_order.json")
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
        order: render_one(order, __MODULE__, "order.json")
      }
    }
  end

  def render("order.json", %{order: order}) do
    %{
      title: order.title,
      status: order.status,
      trackingId: order.tracking_id,
      createdAt: order.inserted_at,
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
      details: order.details
    }
  end
end
