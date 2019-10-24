defmodule LolHero.Auth.EnsureAdmin do
    import Plug.Conn
  
    alias LolHero.Auth.ErrorHandler
  
    def init(opts), do: opts
  
    def call(conn, _opts) do
      current_user = Guardian.Plug.current_resource(conn)
  
      if current_user && current_user.is_admin do
        conn
      else
        conn
        |> ErrorHandler.auth_error({:unauthorized, "resource_not_admin"}, {})
        |> halt()
      end
    end
  end