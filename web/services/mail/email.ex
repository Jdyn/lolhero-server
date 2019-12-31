defmodule LolHero.Email do
  import Bamboo.Email

  def base_email() do
    new_email()
    |> from("admin@lolhero.gg")
  end

  def welcome_email(email) do
    base_email()
    |> to(email)
    |> subject("Welcome test")
    |> html_body("<body>Welcome</body>")
  end

  def order_placed_email(order) do
    %{price: price, title: title} = order

    base_email()
    |> to("gglolhero@gmail.com")
    |> subject("Someone bought something for #{price} - #{title}")
    |> html_body("
      <body>
        <div>
          nice
        </div>
      </body>
      ")
  end

  def order_success_email(email, tracking_id) do
    base_email()
    |> to(email)
    |> subject("We have recieved your order")
    |> html_body("
      <body>
        <span> We have recieved your order. Your Tracking ID is <b>#{tracking_id}</b>. </span>
        <div>
          <p>Additional set-up is required to begin your order.
            <br/>
            <p>
              Please follow <a href=\"http://localhost:3000/order/#{tracking_id}?email=#{email}\">this</a> link to complete your oder.
            </p>
          </p>
        </div>
      </body>
      ")
  end

  def reset_password_email(email, reset_token) do
    base_email()
    |> to(email)
    |> subject("Account Password Recovery")
    |> html_body(
      "
      <body>
        <p>
          Here is a link to change your account password: <a href=\"localhost:3000/account/recover/#{
        reset_token
      }\"> recover </a>
        </p>
      </body>
      "
    )
  end
end
