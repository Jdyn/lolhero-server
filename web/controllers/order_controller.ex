defmodule LolHero.OrderController do
  use LolHero.Web, :controller
  import Ecto
  import Braintree
  alias LolHero.Order
  alias Braintree.ClientToken

  def index(conn, params), do: render(conn, "index.json", orders: Order.find_all())

  def show(conn, params) do
    case Order.find_by(tracking_id: params["id"]) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(LolHero.ErrorView)
        |> render("error.json", error: "Order does not exist.")

      order ->
        render(conn, "show.json", order: order)
    end
  end

  def create_token(conn, params) do
    Application.put_env(:braintree, :merchant_id, "cfcsbff65qmxzrgf")
    Application.put_env(:braintree, :public_key, "q24ty9f2rj3b7r6m")
    Application.put_env(:braintree, :private_key, "1d09f9423d6d58842a31eb24840e6120")

    {:ok, token} = ClientToken.generate(%{version: 3})
    
    render(conn, "token.json", token: token)
  end

  def create(conn, params) do
    tracking_id = Ecto.UUID.generate() |> binary_part(16, 16)

    params
    |> Map.put("tracking_id", to_string(tracking_id))
    |> Order.create()
    |> case do
      {:ok, order} ->
        %{tracking_id: tracking_id, title: title, price: price} = order
        {:ok, transaction} = Braintree.Transaction.sale(%{
          amount: price,
          payment_method_nonce: params["nonce"]
        })

        IO.inspect(transaction)
        conn

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
