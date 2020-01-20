defmodule LolHero.Endpoint do
  use Phoenix.Endpoint, otp_app: :LolHero

  socket("/socket", LolHero.UserSocket,
    websocket: true,
    longpoll: false
  )

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  
  # plug(Plug.Static,
  #   at: "/",
  #   from: :LolHero,
  #   gzip: false,
  #   only: ~w(css fonts images js favicon.ico robots.txt)
  # )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(Plug.Session,
    store: :cookie,
    key: "_LolHero_key",
    signing_salt: "4WQ8s802"
  )

  plug(CORSPlug,
    origin: ["https://lolhero.gg/", "https://lolhero.gg", "http://localhost:3000/", "http://localhost:3000"]
  )

  plug(LolHero.Router)
end
