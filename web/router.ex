defmodule LolHero.Router do
  use LolHero.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1", LolHero do
    pipe_through(:api)

    resources("/variants", VariantController, except: [:edit, :new])
    resources("/products", ProductController, except: [:edit, :new])
    resources("/collections", CollectionController, except: [:edit, :new])
    
    post("/checkout", CheckoutController, :index)

    get("/prices", CategoryController, :prices)

    post("/order", OrderController, :create)
    get("/orders", OrderController, :index)
    # patch("/collection/:id", CollectionController, :update)
    # post("/collection", CollectionController, :create)
    # get("/collections", CollectionController, :list)

    # post("/category", CategoryController, :create)
    # get("/categories", CategoryController, :list)

    # get("/prices/latest", PriceController, :latest)

  end
end
