defmodule LolHero.Router do
  use LolHero.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(LolHero.Auth.Pipeline)
  end

  pipeline :ensure_auth do
    plug(Guardian.Plug.LoadResource, allow_blank: false)
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/api/v1", LolHero do
    pipe_through(:api)

    resources("/variants", VariantController, except: [:edit, :new])
    resources("/products", ProductController, except: [:edit, :new])
    resources("/collections", CollectionController, except: [:edit, :new])
    resources("/categories", CategoryController, except: [:edit, :new])
    resources("/orders", OrderController, except: [:edit, :new])
    resources("/users", UserController, except: [:edit, :new])

    post("/session", SessionController, :create)

    get("/prices", CategoryController, :prices)
  end

  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth])

    resources("/session", SessionController, only: [:show, :delete], singleton: true)

    resources("/account", AccountController, only: [], singleton: true) do
      get("/orders", AccountController, :orders)
    end
  end
end
