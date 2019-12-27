defmodule LolHero.AccountView do
  use LolHero.Web, :view
  alias LolHero.{OrderView, AccountView, UserView}

  def order_list(orders, view) do
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
          orders: render_many(orders.active.orders, AccountView, view, as: :order)
        },
        completed: %{
          title: "Completed Orders",
          count: orders.complete.count,
          orders: render_many(orders.complete.orders, AccountView, view, as: :order)
        }
      }
    }
  end

  def render("order_list.json", %{orders: orders}) do
    order_list(orders, "mini_order.json")
  end

  def render("booster_order_list.json", %{orders: orders}) do
    order_list(orders, "booster_mini_order.json")
  end

  def render("show_order.json", %{order: order}) do
    %{
      ok: true,
      result: %{
        order: render_one(order, OrderView, "full_order.json", as: :order)
      }
    }
  end

  def render("show_booster_order.json", %{order: order}) do
    %{
      ok: true,
      result: %{
        order: render_one(order, OrderView, "full_booster_order.json", as: :order)
      }
    }
  end

  def render("mini_order.json", %{order: order}) do
    %{
      title: order.title,
      status: order.status,
      trackingId: order.tracking_id,
      summonerName: order.details["summonerName"] || "-",
      booster: render_one(order.booster, UserView, "order_user.json", as: :user),
      createdAt: order.inserted_at,
      price: order.price
    }
  end

  def render("booster_mini_order.json", %{order: order}) do
    %{
      title: order.title,
      status: order.status,
      trackingId: order.tracking_id,
      summonerName: order.details["summonerName"] || "-",
      user: render_one(order.user, UserView, "order_user.json", as: :user),
      booster: render_one(order.booster, UserView, "order_user.json", as: :user),
      createdAt: order.inserted_at,
      price: order.price
    }
  end
end
