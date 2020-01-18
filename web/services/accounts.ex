defmodule LolHero.Services.Accounts do
  alias LolHero.{Repo, Order, User}
  import Ecto.Query

  def all_user_orders(id, role) do
    query = order_list_query(id, role)

    query
    |> Repo.all()
    |> Repo.preload([:user, :booster])
    |> case do
      nil ->
        {:error, "No Orders Found."}

      orders ->
        active = Enum.filter(orders, fn order -> order.is_active == true end)
        completed = Enum.filter(orders, fn order -> order.is_complete == true end)

        payload = %{
          boosters: [],
          orders: %{
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
        }

        if role == "admin" do
          boosters =
            Repo.all(
              from(user in User,
                where: user.role == "admin" or user.role == "booster",
                select: user
              )
            )

          payload = Map.put(payload, :boosters, boosters)
          {:ok, payload}
        else
          {:ok, payload}
        end
    end
  end

  def initiate(%{"tracking_id" => tracking_id} = params, user) do
    query = show_order_query(user.id, user.role, tracking_id)

    case Repo.one(query) do
      nil ->
        {:unauthorized, "Order does not exist."}

      order ->
        payload = %{
          account_details: params["accountDetails"],
          details: Map.merge(order.details, params["details"]),
          note: params["note"],
          booster_id: 1
        }

        order
        |> Order.initiation_changeset(payload)
        |> Repo.update()
        |> case do
          {:error, changeset} ->
            {:error, changeset}

          {:ok, order} ->
            {:ok, Repo.preload(order, [:user, :booster])}
        end
    end
  end

  def show_order(id, role, tracking_id) do
    query = show_order_query(id, role, tracking_id)

    query
    |> Repo.one()
    |> Repo.preload(:user)
    |> Repo.preload(:booster)
    |> case do
      nil ->
        {:error, "Order does not exist."}

      order ->
        {:ok, order}
    end
  end

  def change_status(tracking_id, new_status, user) do
    query = show_order_query(user.id, user.role, tracking_id)

    case Repo.one(query) do
      nil ->
        {:unauthorized, "Order does not exist."}

      order ->
        payload = %{
          status: new_status
        }

        order
        |> Order.status_changeset(payload)
        |> Repo.update()
        |> case do
          {:error, changeset} ->
            {:error, changeset}

          {:ok, order} ->
            {:ok, Repo.preload(order, [:user, :booster])}
        end
    end
  end

  def show_order_query(id, role, tracking_id) do
    case role do
      "booster" ->
        from(order in Order,
          where:
            order.user_id == ^id or
              (order.booster_id == ^id and order.tracking_id == ^tracking_id),
          preload: [:user],
          select: order
        )

      "admin" ->
        from(order in Order,
          where: order.tracking_id == ^tracking_id,
          preload: [:user],
          select: order
        )

      "user" ->
        from(order in Order,
          where: order.user_id == ^id and order.tracking_id == ^tracking_id,
          preload: [:user],
          select: order
        )
    end
  end

  def order_list_query(id, role) do
    case role do
      "booster" ->
        from(order in Order,
          where: order.user_id == ^id or order.booster_id == ^id,
          order_by: [desc: order.inserted_at],
          select: order
        )

      "admin" ->
        from(order in Order,
          order_by: [desc: order.inserted_at],
          select: order
        )

      "user" ->
        from(order in Order,
          where: order.user_id == ^id,
          order_by: [desc: order.inserted_at],
          select: order
        )
    end
  end
end
