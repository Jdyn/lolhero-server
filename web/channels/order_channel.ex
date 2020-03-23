defmodule LolHero.OrderChannel do
  use LolHero.Web, :channel
  alias LolHero.{Order, OrderView, Message}

  def join("order:" <> order_id, _params, socket) do
    %{id: id, role: role} = socket.assigns.user

    query = join_query(id, order_id, role)

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

  def handle_in(
        "send:message",
        %{"message" => message},
        socket
      ) do
    "order:" <> tracking_id = socket.topic
    %{id: id} = socket.assigns.user

    order_id =
      Repo.one(from(order in Order, where: order.tracking_id == ^tracking_id, select: order.id))

    payload = %{
      message: message,
      order_id: order_id,
      user_id: id
    }

    {:ok, message} = Message.create(payload)

    broadcast(
      socket,
      "recieve:message",
      OrderView.render("message.json", %{message: message |> Repo.preload(:user)})
    )

    {:noreply, socket}
  end

  def join_query(id, order_id, role) do
    case role do
      "booster" ->
        from(order in Order,
          where:
            (order.tracking_id == ^order_id and order.user_id == ^id) or
              (order.tracking_id == ^order_id and
                 order.booster_id == ^id),
          select: order.id
        )

      "admin" ->
        from(order in Order,
          where: order.tracking_id == ^order_id,
          select: order.id
        )

      "user" ->
        from(order in Order,
          where: order.user_id == ^id and order.tracking_id == ^order_id,
          select: order.id
        )
    end
  end
end
