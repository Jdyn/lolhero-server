defmodule LolHero.OrderChannel do
  use LolHero.Web, :channel
  alias LolHero.{Order, OrderView, Message}

  def join("order:" <> order_id, _params, socket) do
    %{id: id} = socket.assigns.user

    query =
      from(order in Order,
        where: order.user_id == ^id and order.tracking_id == ^order_id,
        select: order.id
      )

    case Repo.one(query) do
      nil ->
        {:error, "Unauthorized"}

      _order ->
        payload = %{message: "success"}
        {:ok, payload, socket}
    end
  end

  def handle_in("request:chat_history", _params, socket) do
    "order:" <> tracking_id = socket.topic

    order = Order.find_by(tracking_id: tracking_id)
    chat_history = LolHero.Message.find_all(order.id)
    response = LolHero.OrderView.render("chat_history.json", %{messages: chat_history})
    {:reply, {:ok, response}, socket}
  end

  def handle_in("send:message", params, socket) do
    payload = %{
      message: params.message,
      order_id: params.orderId,
      user_id: params.userId
    }

    {:ok, message} = Message.create(payload)

    broadcast(
      socket,
      "send:message",
      OrderView.render("message.json", %{message: message |> Repo.preload(:user)})
    )

    {:noreply, socket}
  end
end
