defmodule LolHero.Auth.Pipeline do
    use Guardian.Plug.Pipeline,
      otp_app: :LolHero,
      error_handler: LolHero.Auth.ErrorHandler,
      module: LolHero.Auth.Guardian
  
    plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
    plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end
  