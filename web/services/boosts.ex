defmodule LolHero.Services.Boosts do
  use LolHero.Web, :service

  alias LolHero.{Category, Collection, Product, Variant, Repo}

  def get_base_prices(start_rank, desired_rank, collection_id) do
    query =
      from(v in Variant,
        where:
          v.collection_id == ^collection_id and
            v.product_id >= ^start_rank and
            v.product_id < ^desired_rank,
        order_by: [asc: v.id],
        select: v.base_price
      )

    rank_price_list = Repo.all(query)

    base_price = Enum.reduce(rank_price_list, 0, fn item, acc -> Decimal.add(acc, item) end)
    start_rank_price = Enum.at(rank_price_list, 0)

    {base_price, start_rank_price}
  end

  def get_prices(boost_type, collection_title) do
    query =
      from(
        collection in Collection,
        left_join: category in assoc(collection, :category),
        where: category.title == ^boost_type and collection.title == ^collection_title,
        preload: [:variants],
        select: collection
      )

    target = Repo.one(query)

    Enum.reduce(target.variants, %{}, fn item, prices ->
      Map.put(prices, item.title, item.base_price)
    end)
  end

  def get_title(details) do
    case Repo.one(Category.title_query(details["collectionId"])) do
      [category, collection] ->
        case collection do
          "Division Boost" ->
            case Repo.all(Product.ranks_query(details["startRank"], details["desiredRank"])) do
              [start, finish] ->
                {:ok, "#{category} Boost | #{collection} - #{start} to #{finish}"}
            end

          _ ->
            case Repo.all(Product.ranks_query(details["startRank"], details["desiredRank"])) do
              [start, _] ->
                {:ok, "#{category} Boost | #{details["desiredAmount"]} #{collection} - #{start}"}
            end
        end

      _ ->
        {:error, "invalid collectionId"}
    end
  end
end
