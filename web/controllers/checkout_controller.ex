defmodule LolHero.CheckoutController do
  use LolHero.Web, :controller

  def index(conn, params) do
    body = URI.decode_www_form(params)
    IO.inspect(body)

    # response = HTTPoison.post("https://api.stripe.com/v1/checkout/sessions", json, %{"Authorization" => "bearer sk_test_4eC39HqLyjWDarjtT1zdp7dc", "Content-Type" => "application/x-www-form-urlencoded"})
    # IO.inspect(response)

    conn
  end
end
