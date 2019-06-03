defmodule LolHero.Repo do
  use Ecto.Repo,
    otp_app: :LolHero,
    adapter: Ecto.Adapters.Postgres
end
