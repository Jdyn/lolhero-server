defmodule LolHero.Services.Categories do
  alias LolHero.{Category, Repo}

  def delete(id) do
    error = {:not_found, "Category does not exist."}

    case Category.find(id) do
      nil ->
        error

      category ->
        Repo.delete(category)
    end
  end
end
