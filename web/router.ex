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

    resources("/users", UserController, only: [:index, :create, :show, :update, :delete])
    resources("/orders", OrderController, only: [:index, :create, :show, :update, :delete])
    resources("/variants", VariantController, only: [:index, :create, :show, :update, :delete])
    resources("/products", ProductController, only: [:index, :create, :show, :update, :delete])

    resources("/collections", CollectionController,
      only: [:index, :create, :show, :update, :delete]
    )

    resources("/categories", CategoryController, only: [:index, :create, :show, :update, :delete])

    resources("/order", OrderController, only: [], singleton: true) do
      post("/create", OrderController, :create)
      post("/:tracking_id", OrderController, :track)
      patch("/:tracking_id", OrderController, :initiate)
      post("/:tracking_id/status", OrderController, :change_status)
    end

    resources("/account", AccountController, only: [], singleton: true) do
      post("/login", UserController, :log_in)
      post("/signup", UserController, :create)
      post("/password/reset", UserController, :reset_password)
      patch("/password/update", UserController, :update_password)
    end

    get("/prices", CategoryController, :prices)
  end

  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth])

    get("/account", UserController, :refresh_session)

    resources("/account", AccountController, only: [], singleton: true) do
      get("/orders", AccountController, :orders)
      get("/order/:tracking_id", AccountController, :show_order)
      post("/order/:tracking_id/status", AccountController, :change_status)
      patch("/order/:tracking_id", AccountController, :initiate)
      delete("/logout", UserController, :log_out)
    end
  end

  scope "/api/v1", LolHero do
    pipe_through([:api, :ensure_auth, :ensure_admin])

  end
end
