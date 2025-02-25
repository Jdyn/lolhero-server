defmodule LolHero.OrderController do
  use LolHero.Web, :controller

  alias LolHero.Services.Orders
  alias LolHero.{Order, ErrorView, Email, Mailer}

  def index(conn, _params), do: render(conn, "index.json", orders: Order.find_all())

  def show(conn, params) do
    order = Order.find_by(tracking_id: params["id"]) |> Repo.preload([:user, :booster, messages: [:user]])
    render(conn, "show.json", order: order)
  end

  def track(conn, %{"tracking_id" => tracking_id, "email" => email}) do
    case Orders.authenticate(tracking_id, email) do
      {:ok, order} ->
        render(conn, "show.json", order: order)

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(LolHero.ErrorView)
        |> render("error.json", error: reason)
    end
  end

  def update(conn, %{"id" => id} = params) do
    Order.find_by(tracking_id: id)
    |> Order.update(params)
    |> case do
      {:ok, new_order} ->
        conn
        |> put_status(:ok)
        |> render("booster_show.json", order: new_order |> Repo.preload([:user, :booster, messages: [:user]]))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def initiate(conn, params) do
    params
    |> Orders.initiate()
    |> case do
      {:ok, order} ->
        render(conn, "show.json", order: order)

      {:unauthorized, reason} ->
        conn
        |> put_status(:not_found)
        |> put_view(LolHero.ErrorView)
        |> render("error.json", error: reason)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def change_status(conn, params) do
    case Orders.change_status(params) do
      {:ok, order} ->
        conn
        |> put_status(:ok)
        |> render("show.json", order: order)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(LolHero.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def create(conn, params) do
    tracking_id = Nanoid.generate()

    case Order.find_by(tracking_id: tracking_id) do
      nil ->
        case Guardian.Plug.current_resource(conn) do
          nil ->
            params
            |> Map.put("tracking_id", to_string(tracking_id))
            |> Order.create()
            |> case do
              {:ok, order} ->
                %{tracking_id: tracking_id, email: email} = order
                success_url = "/order/success/#{tracking_id}/"

                Email.order_success_email(email, tracking_id)
                |> Mailer.deliver_now()

                Email.order_placed_email(order)
                |> Mailer.deliver_now()

                conn
                |> put_status(:ok)
                |> render("created.json", %{order: order, success_url: success_url})

              {:error, changeset} ->
                conn
                |> put_status(:ok)
                |> put_view(ErrorView)
                |> render("changeset_error.json", changeset: changeset)
            end

          user ->
            params
            |> Map.put("tracking_id", to_string(tracking_id))
            |> Map.put("user_id", user.id)
            |> Order.create()
            |> case do
              {:ok, order} ->
                %{tracking_id: tracking_id, email: email} = order

                success_url = "/order/success/#{tracking_id}/"

                Email.account_order_success_email(email, tracking_id)
                |> Mailer.deliver_now()

                Email.order_placed_email(order)
                |> Mailer.deliver_now()

                conn
                |> put_status(:ok)
                |> render("created.json", %{order: order, success_url: success_url})

              {:error, changeset} ->
                conn
                |> put_status(:ok)
                |> put_view(ErrorView)
                |> render("changeset_error.json", changeset: changeset)
            end
        end

      _order ->
        create(conn, params)
    end
  end
end
