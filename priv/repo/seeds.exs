# mix run priv/repo/seeds.exs

alias LolHero.{
  Repo,
  Category,
	Collection,
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

Repo.insert!(%Product{
	title: "Master",
	description: "Master Tier - Division I"
})

Repo.insert!(%Product{
	title: "Grandmaster",
	description: "Grandmaster Tier - Division I"
})

Repo.insert!(%Product{
	title: "Challenger",
	description: "Challenger Tier - Division I"
})
