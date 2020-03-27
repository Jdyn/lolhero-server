defmodule LolHero.Services.Collections do
  alias LolHero.{Collection, Repo}

  def delete(id) do
    error = {:not_found, "Collection does not exist."}

    case Repo.get(Collection, id) do
      nil ->
        error

      collection ->
        Repo.delete(collection)
    end
  end

  def find(id) do
    Collection
    |> Repo.get(id)
    |> Repo.preload(variants: [:product])
  end
end
