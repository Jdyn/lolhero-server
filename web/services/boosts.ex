defmodule LolHero.Services.Boosts do
  alias LolHero.{Collection}

  def set_price(changeset, details) do
    case Collection.find_by(%{id: 1}) do
      collection ->
        case collection.title do
          "Division Boost" ->
            price = division_boost_price(collection.id, details)

          _ ->
            IO.inspect("ELSE")
        end

      nil ->
        nil
    end
  end

  defp division_boost_price(id, details) do
    
  end
end
