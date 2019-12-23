defmodule LolHero.SeedFactory do
  import Ecto.Query

  def categories() do
    [
      %{
        title: "Solo",
        description: "Our Booster will log into your account to complete the boost."
      },
      %{
        title: "Duo",
        description: "You will play along side our booster while you are on your account."
      }
    ]
  end

  def collections() do
    [
      %{
        category_id: 1,
        title: "Division Boost",
        description: "We play the required amount of games to reach the division you select."
      },
      %{
        category_id: 1,
        title: "Placement Games",
        description: "We play your selected amount of placement matches."
      },
      %{
        category_id: 1,
        title: "Net Wins",
        description:
          "We guarantee a win/loss ratio of 2:1 where each loss would add an additional 2 wins."
      },
      %{
        category_id: 1,
        title: "Net Games",
        description: "Low cost, guaranteeing high performance without a guaranteed win rate."
      },
      %{
        category_id: 2,
        title: "Division Boost",
        description: "We play the required amount of games to reach the division you select."
      },
      %{
        category_id: 2,
        title: "Placement Games",
        description: "We play your selected amount of placement matches."
      },
      %{
        category_id: 2,
        title: "Net Wins",
        description:
          "We guarantee a win/loss ratio of 2:1 where each loss would add an additional 2 wins."
      },
      %{
        category_id: 2,
        title: "Net Games",
        description: "Low cost, guaranteeing high performance without a guaranteed win rate."
      },
      %{
        category_id: 1,
        title: "servers",
        description: "Solo - Servers"
      },
      %{
        category_id: 1,
        title: "queues",
        description: "Solo - Queue Types"
      },
      %{
        category_id: 1,
        title: "lp",
        description: "Solo - League Points"
      },
      %{
        category_id: 1,
        title: "promotions",
        description: "Solo Promotional Series"
      },
      %{
        category_id: 1,
        title: "modifiers",
        description: "Solo - Modifiers"
      },
      %{
        category_id: 2,
        title: "servers",
        description: "Duo - Servers"
      },
      %{
        category_id: 2,
        title: "queues",
        description: "Duo - Queue Types"
      },
      %{
        category_id: 2,
        title: "lp",
        description: "Duo - League Points"
      },
      %{
        category_id: 2,
        title: "promotions",
        description: "Duo Promotional Series"
      },
      %{
        category_id: 2,
        title: "modifiers",
        description: "Duo - Modifiers"
      }
    ]
  end

  def boost_items() do
    tiers = [
      "Iron",
      "Bronze",
      "Silver",
      "Gold",
      "Platinum",
      "Diamond"
    ]

    roman_divisions = [
      "IV",
      "III",
      "II",
      "I"
    ]

    numerical_divisions = [
      "4",
      "3",
      "2",
      "1"
    ]

    products = []

    result =
      for tier <- tiers do
        for index <- 0..3 do
          new_list =
            List.insert_at(products, 0, %{
              title: "#{tier} #{Enum.at(roman_divisions, index)}",
              description: "#{tier} Tier - Division #{Enum.at(numerical_divisions, index)}"
            })

          products = new_list
        end
      end

    List.flatten(result)
  end

  def products() do
    extras = [
      %{
        title: "Master",
        description: "Master Tier - Division I"
      },
      %{
        title: "Grandmaster",
        description: "Grandmaster Tier - Division I"
      },
      %{
        title: "Challenger",
        description: "Challenger Tier - Division I"
      },
      %{
        title: "LP",
        description: "League Points"
      },
      %{
        title: "Promotions",
        description: "Promotional Series"
      },
      %{
        title: "Servers",
        description: "Servers"
      },
      %{
        title: "Queues",
        description: "Queue Types"
      },
      %{
        title: "Modifiers",
        description: "Modifiers"
      }
    ]

    boost_items() ++ extras
  end

  def variants() do
    products =
      LolHero.Repo.all(
        from(p in LolHero.Product,
          where:
            p.title != ^"Servers" and p.title != ^"Queues" and p.title != ^"Modifiers" and
              p.title != ^"LP"
        )
      )

    ranks =
      LolHero.Repo.all(
        from(c in LolHero.Collection,
          where:
            c.title != ^"servers" and c.title != ^"queues" and c.title != ^"modifiers" and
              c.title != ^"lp"
        )
      )

    variants = []

    result =
      for collection <- ranks do
        for product <- products do
          new_list =
            List.insert_at(variants, 0, %{
              product_id: product.id,
              collection_id: collection.id,
              title: product.title,
              description: product.description,
              base_price: 10
            })

          variants = new_list
        end
      end

    ranks = List.flatten(result)

    # other_collections =
    #   LolHero.Repo.all(
    #     from(c in LolHero.Collection,
    #       where:
    #         c.title == "servers" or c.title == "queues" or c.title == "modifiers" or
    #           c.title == "lp" or c.title == "promotions"
    #     )
    #   )

    # other_products =
    #   LolHero.Repo.all(
    #     from(p in LolHero.Product,
    #       where:
    #         p.title == "Servers" or p.title == "Queues" or p.title == "Modifiers" or
    #           p.title == "LP" or p.title == "Promotions"
    #     )
    #   )

    # other_variants = []

    # others =
    #   for collection <- other_collections do
    #     for product <- other_products do
    #       new_list =
    #         List.insert_at(other_variants, 0, %{
    #           product_id: product.id,
    #           collection_id: collection.id,
    #           title: product.title,
    #           description: product.description,
    #           base_price: 10
    #         })

    #       other_variants = new_list
    #     end
    #   end

    # others = List.flatten(others)

    # ranks ++ others
  end
end
