defmodule LolHero.MixProject do
  use Mix.Project

  def project do
    [
      app: :LolHero,
      version: "0.1.0",
      elixir: "~> 1.10.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {LolHero, []},
      extra_applications: [:logger, :runtime_tools, :braintree, :bamboo, :edeliver]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.4.15"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.3.4"},
      {:postgrex, "~> 0.15.3"},
      {:jason, "~> 1.1.2"},
      {:plug_cowboy, "~> 2.1"},
      {:cors_plug, "~> 2.0"},
      {:pbkdf2_elixir, "~> 1.2"},
      {:guardian, "~> 2.0.0"},
      {:braintree, "~> 0.10.0"},
      {:bamboo, "~> 1.3"},
      {:nanoid, "~> 2.0.2"},
      {:edeliver, ">= 1.7.0"},
      {:distillery, "~> 2.1", warn_missing: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
