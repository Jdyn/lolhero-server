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

  def render("show.json", %{order: order}) do
    %{
      ok: true,
      result: %{
        order: render_one(order, __MODULE__, "order.json")
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

  def render("created.json", %{order: order}) do
    %{
      ok: true,
      result: %{
        order: render_one(order, __MODULE__, "order.json")
      }
    }
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      title: order.title,
      type: order.type,
      status: order.status,
      paid: order.paid,
      price: order.price,
      tracking_id: order.tracking_id,
      details: order.details,
      note: order.note
    }
  end
end
