defmodule LolHero.Services.Users do
  use Timex

  alias LolHero.{Repo, User, Email, Mailer}
  alias LolHero.Services.Sessions

  def create(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        user_with_token = Sessions.user_with_token(user)

        Email.welcome_email(user.email)
        |> Mailer.deliver_now()

        {:ok, user_with_token}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def reset_password(params) do
    email = params["email"]

    user =
      case email do
        nil ->
          nil

        email ->
          User.find_by(email: email)
      end

    case user do
      nil ->
        {:error, "invalid email"}

      user ->
        user_with_token = create_reset_token(user)

        Email.reset_password_email("email", user_with_token.reset_token)
        |> Mailer.deliver_now()

        {:ok, user_with_token}
    end
  end

  def update_password(params) do
    case Repo.get_by(User, reset_token: params["resetToken"]) do
      nil ->
        {:unauthorized, "Your reset link is invalid. Please request a new link."}

      user ->
        if expired?(user.reset_token_expiry) do
          payload = %{
            reset_token: nil,
            reset_token_expiry: nil
          }

          user
          |> User.password_token_changeset(payload)
          |> Repo.update!()

          {:expired, "This reset link has expired. Please request a new link."}
        else
          user
          |> User.password_update_changeset(params)
          |> Repo.update()
          |> case do
            {:ok, user} ->
              payload = %{
                reset_token: nil,
                reset_token_expiry: nil
              }

              user
              |> User.password_token_changeset(payload)
              |> Repo.update()
              |> case do
                {:ok, new_user} ->
                  {:ok, new_user}

                {:error, changeset} ->
                  {:error, changeset}
              end

            {:error, changeset} ->
              {:error, changeset}
          end
        end
    end
  end

  def create_reset_token(user) do
    token = random_string(48)
    sent_at = DateTime.utc_now()

    payload = %{
      reset_token: token,
      reset_token_expiry: sent_at
    }

    user
    |> User.password_token_changeset(payload)
    |> Repo.update!()
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  defp expired?(datetime) do
    Timex.after?(Timex.now(), Timex.shift(datetime, days: 1))
  end

  def is_booster(user) do
    if user.role == "booster" do
      true
    else
      true
    end
  end
end
