defmodule LolHero.Endpoint do
  use Phoenix.Endpoint, otp_app: :LolHero

  socket("/socket", LolHero.Socket,
    websocket: true,
    longpoll: false
  )

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
    origin: ["*"]
  )

  plug(LolHero.Router)
end
