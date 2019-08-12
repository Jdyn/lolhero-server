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
