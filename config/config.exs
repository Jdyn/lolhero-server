# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :LolHero,
  ecto_repos: [LolHero.Repo]

# Configures the endpoint
config :LolHero, LolHero.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "efji1xS0LJo2ZlgiwoSjjUI+11SiZpO+F+i+3OE0Znl3mMOGj19Xx9yEO3LuIteG",
  render_errors: [view: LolHero.ErrorView, accepts: ~w(json)],
  pubsub: [name: LolHero.PubSub, adapter: Phoenix.PubSub.PG2]

config :LolHero, LolHero.Auth.Guardian,
  issuer: "LolHero",
  ttl: {7, :days},
  secret_key: "0GgeeYRkTioaFSWvXwdKoyfux2T0KdI4iVjl/wqJdPYEBZMOuDWdluvo6PexcAIL"

  config :nanoid,
  size: 5,
  alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
