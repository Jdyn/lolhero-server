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
    resources("/categories", CategoryController, except: [:edit, :new])

    post("/checkout", OrderController, :create)

    get("/prices", CategoryController, :prices)
    post("/order", OrderController, :create)
    get("/orders", OrderController, :index)
  end
end
