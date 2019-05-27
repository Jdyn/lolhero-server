defmodule LolHero.Router do
  use LolHero.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LolHero do
    pipe_through :api
  end
end
