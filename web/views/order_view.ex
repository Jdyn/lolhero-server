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

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      tracking_id: order.tracking_id,
      details: order.details
    }
  end
end
