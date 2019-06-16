defmodule LolHero.SeedFactory do
  def categories() do
    categories = [
      %{
        title: "Solo Boost",
        description: "Our Booster will log into your account to complete the boost."
      },
      %{
        title: "Duo Boost",
        description: "You will play along side our booster while you are on your account."
      }
    ]
  end

  def collections() do
    collections = [
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
      }
    ]
  end

  def products() do
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
end

# products = [
# 	%{
# 		title: "Iron IV",
# 		description: "Iron Tier - Divison 4"
# 	},
# 	%{
# 		title: "Iron III",
# 		description: "Iron Tier - Divison 3"
# 	},
# 	%{
# 		title: "Iron II",
# 		description: "Iron Tier - Divison 2"
# 	},
# 	%{
# 		title: "Iron I",
# 		description: "Iron Tier - Divison 1"
# 	},
# 	%{
# 		title: "Bronze IV",
# 		description: "Bronze Tier - Divison 4"
# 	},
# 	%{
# 		title: "Bronze III",
# 		description: "Bronze Tier - Divison 3"
# 	},
# 	%{
# 		title: "Bronze II",
# 		description: "Bronze Tier - Divison 2"
# 	},
# 	%{
# 		title: "Bronze I",
# 		description: "Silver Tier - Divison 1"
# 	},
# 	%{
# 		title: "Silver IV",
# 		description: "Silver Tier - Divison 4"
# 	},
# 	%{
# 		title: "Silver III",
# 		description: "Silver Tier - Divison 3"
# 	},
# 	%{
# 		title: "Silver II",
# 		description: "Silver Tier - Divison 2"
# 	},
# 	%{
# 		title: "Silver I",
# 		description: "Silver Tier - Divison 1"
# 	},

# ]
