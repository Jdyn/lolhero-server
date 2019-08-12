defmodule LolHero.AccountView do
  use LolHero.Web, :view
  alias LolHero.{OrderView, User}

  def render("order_list.json", %{orders: orders}) do
    %{
      ok: true,
      result: %{
        total: %{
          title: "Total Orders",
          count: orders.total_count
        },
        active: %{
          title: "Active Orders",
          count: orders.active.count,
          orders: render_many(orders.active.orders, OrderView, "order.json", as: :order)
        },
        completed: %{
          title: "Completed Orders",
          count: orders.complete.count,
          orders: render_many(orders.complete.orders, OrderView, "order.json", as: :order)
        }
      }
    }
  end
end
