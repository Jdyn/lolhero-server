defmodule LolHero.Router do
  use LolHero.Web, :router

  default_routes = [:index, :create, :show, :update, :delete]

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

    resources("/users", UserController, only: default_routes)
    resources("/orders", OrderController, only: default_routes)
    resources("/variants", VariantController, only: default_routes)
    resources("/products", ProductController, only: default_routes)
    resources("/collections", CollectionController, only: default_routes)
    resources("/categories", CategoryController, only: default_routes)

    resources("/order", OrderController, only: [], singleton: true) do
      post("/create", OrderController, :create)
      post("/:tracking_id", OrderController, :track)
      patch("/:tracking_id", OrderController, :initiate)
      post("/:tracking_id/status", OrderController, :change_status)
    end

    resources("/account", AccountController, only: [], singleton: true) do
      post("/login", SessionController, :create)
      post("/signup", UserController, :create)
      post("/password/reset", UserController, :reset_password)
      patch("/password/update", UserController, :update_password)
    end

    get("/prices", CategoryController, :prices)
  end

  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth])

    get("/account", SessionController, :show)

    resources("/account", AccountController, only: [], singleton: true) do
      get("/orders", AccountController, :orders)
      get("/order/:tracking_id", AccountController, :show_order)
      post("/order/:tracking_id/status", AccountController, :change_status)
      patch("/order/:tracking_id", AccountController, :initiate)
      delete("/logout", SessionController, :delete)
    end
  end

  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth, :ensure_admin])

    # resources("/users", UserController, only: default_routes)
    # resources("/orders", OrderController, only: default_routes)
    # resources("/variants", VariantController, only: default_routes)
    # resources("/products", ProductController, only: default_routes)
    # resources("/collections", CollectionController, only: default_routes)
    # resources("/categories", CategoryController, only: default_routes)
  end
end
