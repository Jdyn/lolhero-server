defmodule LolHero.Email do
  import Bamboo.Email

  def base_email() do
    new_email()
    |> from("noreply@lolhero.gg")
  end

  def welcome_email(email) do
    base_email()
    |> to(email)
    |> subject("Welcome test")
    |> html_body("<body>Welcome</body>")
  end

  def order_success_email(email, tracking_id) do
    base_email()
    |> to(email)
    |> subject("Thank you for your order.")
    |> html_body(
      "<body>We have recieved your order. Your Tracking ID is <b>#{tracking_id}</b>. You can oversee your order within your account or from <a href=\"http://lolhero.gg/track/#{
        tracking_id
      }\">here</a> or our home page.</body>"
    )
  end
end
