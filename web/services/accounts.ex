defmodule LolHero.Services.Accounts do
  alias LolHero.{Repo, Order}
  import Ecto.Query

  def all_orders(id) do
    query =
      from(order in Order,
        where: order.user_id == ^id,
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
end
