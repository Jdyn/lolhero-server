defmodule LolHero.CheckoutController do
  use LolHero.Web, :controller

  def index(conn, params) do
    payload = Stripe.Util.atomize_keys(params)

    case Stripe.Session.create(payload) do
      {:ok, session} ->
        conn
        |> put_status(:ok)
        |> render("index.json", session: session)

      {:error, error} ->
        IO.inspect(error)

        conn
        |> put_status(:not_found)
        |> render("error.json", error: error)
    end
  end
end
