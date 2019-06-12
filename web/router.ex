defmodule LolHero.Router do
  use LolHero.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1", LolHero do
    pipe_through(:api)

    post("/checkout", CheckoutController, :index)
    post("/product", ProductController, :create_product)
    post("/product/variant", ProductController, :create_variant)
    
    post("/collection", CollectionController, :create)
    post("/category", CategoryController, :create)

  end
end
