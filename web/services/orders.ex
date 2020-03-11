defmodule LolHero.Services.Orders do
  use LolHero.Web, :service

  alias LolHero.{Order, Repo}

  def authenticate(tracking_id, email) do
    query =
      from(o in Order,
        where: o.tracking_id == ^tracking_id and o.email == ^email,
        preload: [:user],
        select: o
      )

    query
    |> Repo.one()
    |> Repo.preload([:user, :booster])
    |> case do
      nil ->
        {:error, "That combination does not exist. Please try again."}

      order ->
        {:ok, order}
    end
  end

  def change_status(params) do
    case authenticate(params["tracking_id"], params["email"]) do
      {:error, reason} ->
        {:unauthorized, reason}

      {:ok, order} ->
        payload = %{
          status: params["status"]
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

  def initiate(params) do
    case authenticate(params["tracking_id"], params["email"]) do
      {:error, reason} ->
        {:unauthorized, reason}

      {:ok, order} ->
        payload = %{
          account_details: params["accountDetails"],
          details: Map.merge(order.details, params["details"]),
          note: params["note"],
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
end
