# mix run priv/repo/seeds.exs

alias LolHero.{
  Repo,
  Category,
  Collection,
  Variant,
  Product,
  SeedFactory
}

#
#   Create Categories
#
categories = SeedFactory.categories()

for item <- categories do
  Repo.insert!(%Category{
    title: item.title,
    description: item.description
  })
end

#
#   Create Collections
#
collections = SeedFactory.collections()

for item <- collections do
  Repo.insert!(%Collection{
    category_id: item.category_id,
    title: item.title,
    description: item.description
  })
end

#
# Create Products
#
products = SeedFactory.products()

for item <- products do
  Repo.insert!(%Product{
    title: item.title,
    description: item.description
  })
end

#
# Create Variants
#
variants = SeedFactory.variants()

for item <- variants do
  Repo.insert!(%Variant{
    product_id: item.product_id,
    collection_id: item.collection_id,
    title: item.title,
    description: item.description,
    base_price: 10
  })
end

extras = [
  #
  # Unranked Tier
  #
  %Variant{
    base_price: 10,
    product_id: 28,
    collection_id: 2,
    title: "Unranked"
  }
  #
  # Solo LP
  #
  %Variant{
    base_price: 1,
    product_id: 28,
    collection_id: 11,
    title: "20"
  },
  %Variant{
    base_price: 0.9,
    product_id: 28,
    collection_id: 11,
    title: "40"
  },
  %Variant{
    base_price: 0.8,
    product_id: 28,
    collection_id: 11,
    title: "60"
  },
  %Variant{
    base_price: 0.7,
    product_id: 28,
    collection_id: 11,
    title: "80"
  },
  %Variant{
    base_price: 0.6,
    product_id: 28,
    collection_id: 11,
    title: "90"
  },
  %Variant{
    base_price: 0.5,
    product_id: 28,
    collection_id: 11,
    title: "99"
  },
  %Variant{
    base_price: 1,
    product_id: 28,
    collection_id: 11,
    title: "100"
  },
  #
  # Duo LP
  #
  %Variant{
    base_price: 1,
    product_id: 28,
    collection_id: 16,
    title: "20"
  },
  %Variant{
    base_price: 0.9,
    product_id: 28,
    collection_id: 16,
    title: "40"
  },
  %Variant{
    base_price: 0.8,
    product_id: 28,
    collection_id: 16,
    title: "60"
  },
  %Variant{
    base_price: 0.7,
    product_id: 28,
    collection_id: 16,
    title: "80"
  },
  %Variant{
    base_price: 0.6,
    product_id: 28,
    collection_id: 16,
    title: "90"
  },
  %Variant{
    base_price: 0.5,
    product_id: 28,
    collection_id: 16,
    title: "99"
  },
  %Variant{
    base_price: 1,
    product_id: 28,
    collection_id: 16,
    title: "100"
  },
  #
  # Solo Promotions
  #
  %Variant{
    base_price: 0.7,
    product_id: 29,
    collection_id: 12,
    title: "-1"
  },
  %Variant{
    base_price: 0.8,
    product_id: 29,
    collection_id: 12,
    title: "-2"
  },
  %Variant{
    base_price: 0.5,
    product_id: 29,
    collection_id: 12,
    title: "0"
  },
  %Variant{
    base_price: 0.4,
    product_id: 29,
    collection_id: 12,
    title: "1"
  },
  %Variant{
    base_price: 0.3,
    product_id: 29,
    collection_id: 12,
    title: "2"
  },
  #
  # Duo Promotions
  #
  %Variant{
    base_price: 0.7,
    product_id: 29,
    collection_id: 17,
    title: "-1"
  },
  %Variant{
    base_price: 0.8,
    product_id: 29,
    collection_id: 17,
    title: "-2"
  },
  %Variant{
    base_price: 0.5,
    product_id: 29,
    collection_id: 17,
    title: "0"
  },
  %Variant{
    base_price: 0.4,
    product_id: 29,
    collection_id: 17,
    title: "1"
  },
  %Variant{
    base_price: 0.3,
    product_id: 29,
    collection_id: 17,
    title: "2"
  },
  #
  # Solo Modifiers
  #
  %Variant{
    base_price: 1.2,
    product_id: 32,
    collection_id: 13,
    title: "express"
  },
  %Variant{
    base_price: 1.05,
    product_id: 32,
    collection_id: 13,
    title: "incognito"
  },
  %Variant{
    base_price: 0.95,
    product_id: 32,
    collection_id: 13,
    title: "unrestricted"
  },
  #
  # Duo Modifiers
  #
  %Variant{
    base_price: 1.2,
    product_id: 32,
    collection_id: 18,
    title: "express"
  },
  %Variant{
    base_price: 1.05,
    product_id: 32,
    collection_id: 18,
    title: "incognito"
  },
  %Variant{
    base_price: 0.95,
    product_id: 32,
    collection_id: 18,
    title: "unrestricted"
  },
  #
  # Solo Queue Modes
  #
  %Variant{
    base_price: 0.95,
    product_id: 31,
    collection_id: 10,
    title: "Flex"
  },
  %Variant{
    base_price: 1,
    product_id: 31,
    collection_id: 10,
    title: "Solo"
  },
  #
  # Duo Queue Modes
  #
  %Variant{
    base_price: 0.95,
    product_id: 31,
    collection_id: 15,
    title: "Flex"
  },
  %Variant{
    base_price: 1,
    product_id: 31,
    collection_id: 15,
    title: "Solo"
  },
  #
  # Solo Servers
  #
  %Variant{
    base_price: 1,
    product_id: 30,
    collection_id: 9,
    title: "NA"
  },
  #
  # Duo Servers
  #
  %Variant{
    base_price: 1,
    product_id: 30,
    collection_id: 14,
    title: "NA"
  }
]

for item <- extras do
  Repo.insert!(item)
end
