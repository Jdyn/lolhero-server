defmodule LolHero.Email do
  import Bamboo.Email

  def base_email() do
    new_email()
    |> from("support@lolhero.gg")
  end

  def welcome_email(email) do
    base_email()
    |> to(email)
    |> subject("Welcome to LoL Hero!")
    |> html_body("
    <body>
    <p>Once you place an order you will be able to access
    
    </body>
    ")
  end

  def order_placed_email(order) do
    %{price: price, title: title, details: details} = order

    base_email()
    |> to("gglolhero@gmail.com")
    |> subject("NEW ORDER - $#{price} - #{details["boostType"]} Boost | #{title}")
    |> html_body("
      <body>
        <div>
          Nice.
        </div>
      </body>
      ")
  end

  def account_order_success_email(email, tracking_id) do
    url = Application.get_env(:LolHero, LolHero.Endpoint)[:mail_url]

    base_email()
    |> to(email)
    |> subject("We have recieved your order")
    |> html_body("
      <body>
        <h1>We have recieved your order.</h1>
        <span>Thank you for using LoL Hero. Your Tracking ID is <b>#{tracking_id}</b>. </span>
        <div>
          <p>Additional set-up is required to begin your order.
            <br/>
            <p>
              Please go to your <a href=\"#{url}/account/dashboard\">dashboard</a> to complete your order.
            </p>
          </p>
        </div>
      </body>
      ")
  end

  def order_success_email(email, tracking_id) do
    url = Application.get_env(:LolHero, LolHero.Endpoint)[:mail_url]

    base_email()
    |> to(email)
    |> subject("We have recieved your order")
    |> html_body("
      <body>
        <h1>We have recieved your order.</h1>
        <span>Thank you for using LoL Hero. Your Tracking ID is <b>#{tracking_id}</b>. </span>
        <div>
          <p>Additional set-up is required to begin your order.
            <br/>
            <p>
              Please follow <a href=\"#{url}/order/track/#{tracking_id}?email=#{email}\">this</a> link to complete your order.
            </p>
          </p>
        </div>
      </body>
      ")
  end

  def reset_password_email(email, reset_token) do
    url = Application.get_env(:LolHero, LolHero.Endpoint)[:mail_url]

    base_email()
    |> to(email)
    |> subject("Account Password Recovery")
    |> html_body("
      <body>
        <p>
          Here is the link to reset your password: <a href=\"#{url}/account/recover/#{reset_token}\"> recover </a>
        </p>
      </body>
      ")
  end
end
