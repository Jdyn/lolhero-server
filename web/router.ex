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

  pipeline :ensure_admin do
    plug(LolHero.Auth.EnsureAdmin)
  end

  if Mix.env() == :dev do
    forward("/sent_emails", Bamboo.SentEmailViewerPlug)
  end

  scope "/api/v1", LolHero do
    pipe_through(:api)

    post("/order/:tracking_id", OrderController, :track)
    patch("/order/:tracking_id", OrderController, :initiate)

    resources("/users", UserController, except: [:edit, :new])
    resources("/orders", OrderController, except: [:edit, :new])

    post("/session", SessionController, :create)
    get("/prices", CategoryController, :prices)

    # get("/test", OrderController, :test)
  end

  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth])

    resources("/session", SessionController, only: [:show, :delete], singleton: true)

    resources("/account", AccountController, only: [], singleton: true) do
      get("/orders", AccountController, :orders)
      get("/order/:tracking_id", AccountController, :show_order)
      patch("/order/:tracking_id", AccountController, :initiate)
    end
  end
 
  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth, :ensure_admin])

    resources("/variants", VariantController, except: [:edit, :new])
    resources("/products", ProductController, except: [:edit, :new])
    resources("/collections", CollectionController, except: [:edit, :new])
    resources("/categories", CategoryController, except: [:edit, :new])

    # resources("/account", Admin.AccountController, only: [], singleton: true) do
    #   get("/orders", Admin.AccountController, :orders)
    #   get("/order/:tracking_id", AccountController, :show_order)
    #   patch("/order/:tracking_id", AccountController, :initiate)
    # end
  end
end
