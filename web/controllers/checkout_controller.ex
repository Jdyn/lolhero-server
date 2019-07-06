defmodule LolHero.CheckoutController do
  use LolHero.Web, :controller

  alias LolHero.{Repo, Variant, Category, Product, Collection}

  def create(conn, %{"type" => type} = params) do
    params
    |> Checkout.create()

    conn

    # total_price = calculate_price(params)

    # [start_rank, desired_rank] =
    #   Repo.all(
        # from(
        #   p in Product,
        #   where: p.id == ^params["start_rank"] or p.id == ^params["desired_rank"],
        #   select: p.title
        # )
    #   )

    # [category_title, collection_title] =
    #   Repo.one(
    #     from(cc in Collection,
    #       where: cc.id == ^params["collection_id"],
    #       join: c in Category,
    #       on: [id: cc.category_id],
    #       select: [c.title, cc.title]
    #     )
    #   )

    # title =
    #   String.upcase(category_title) <>
    #     " | " <> collection_title <> " - " <> start_rank <> " to " <> desired_rank

    # payload = %{
    #   payment_method_types: ["card"],
    #   line_items: [
    #     %{
    #       name: title,
    #       amount: Decimal.to_integer(Decimal.mult(total_price, 100)),
    #       currency: "usd",
    #       quantity: 1
    #     }
    #   ],
    #   success_url: "http://localhost:3000/success",
    #   cancel_url: "http://localhost:3000/boost"
    # }

    # #   payload = Stripe.Util.atomize_keys(params)
    # case Stripe.Session.create(payload) do
    #   {:ok, session} ->
    #     conn
    #     |> put_status(:ok)
    #     |> render("index.json", session: session)

    #   {:error, error} ->
    #     IO.inspect(error)

    #     conn
    #     |> put_status(:not_found)
    #     |> render("error.json", error: error)
    # end
  end

  def calculate_price(params) do
    Variant.get_base_price(params)
  end
end

# {
#   "payment_method_types": [
#       "card"
#   ],
#   "line_items": [
#       {
#           "name": "item 1",
#           "amount": 50,
#           "currency": "usd",
#           "quantity": 1
#       },
#       {
#           "name": "item 2",
#           "amount": 100,
#           "currency": "usd",
#           "quantity": 1
#       }
#   ],
#   "success_url": "http://successurl",
#   "cancel_url": "http://cancelurl"
# }
