defmodule LolHero.Services.Users do
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
end
