defmodule LolHero.Auth.ErrorHandler do
  use Phoenix.Controller

  import Plug.Conn

  alias LolHero.ErrorView

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("error.json", error: "An authentication error has occurred.")
  end
end
