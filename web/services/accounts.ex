defmodule LolHero.Services.Accounts do
  alias LolHero.{Repo, Order}
  import Ecto.Query

  def all_orders(id) do
    query =
      from(order in Order,
        where: order.user_id == ^id,
        order_by: [desc: order.inserted_at],
        select: order
      )

    case Repo.all(query) do
      nil ->
        {:error, "No Orders Found."}

      orders ->
        active = Enum.filter(orders, fn order -> order.is_active == true end)
        completed = Enum.filter(orders, fn order -> order.is_complete == true end)

        orders = %{
          total_count: length(active) + length(completed),
          active: %{
            count: length(active),
            orders: active
          },
          complete: %{
            count: length(completed),
            orders: completed
          }
        }

        {:ok, orders}
    end
  end

  def initiate(%{"tracking_id" => tracking_id} = params, user) do
    query =
      from(o in Order,
        where: o.tracking_id == ^tracking_id and o.user_id == ^user.id,
        select: o
      )

    case Repo.one(query) do
      nil ->
        {:unauthorized, "Order does not exist."}

      order ->
        payload = %{
          account_details: params["accountDetails"],
          details: Map.merge(order.details, params["details"]),
          note: params["note"]
        }

        order
        |> Order.initiation_changeset(payload)
        |> Repo.update()
        |> case do
          {:error, changeset} ->
            {:error, changeset}

          {:ok, order} ->
            {:ok, order}
        end
    end
  end

  def show_order(user_id, tracking_id) do
    query =
      from(order in Order,
        where: order.user_id == ^user_id and order.tracking_id == ^tracking_id,
        select: order
      )

    case Repo.one(query) do
      nil ->
        {:error, "Order does not exist."}

      order ->
        {:ok, order}
    end
  end
end
