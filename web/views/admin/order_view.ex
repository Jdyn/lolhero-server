defmodule LolHero.Admin.OrderView do
    use LolHero.Web, :view
  
    alias LolHero.{UserView, OrderView}

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
  