defmodule LolHero.Services.Orders do
  use LolHero.Web, :service

  alias LolHero.{Order, Repo}

  def authenticate(tracking_id, email) do
    query =
      from(o in Order,
        where: o.tracking_id == ^tracking_id and o.email == ^email,
        select: o
      )

    case Repo.one(query) do
      nil ->
        {:error, "That combination does not exist. Try a different one."}

      order ->
        {:ok, order}
    end
  end
end
