defmodule LolHero.Services.Users do
  alias LolHero.{Repo, User}
  alias LolHero.Services.Sessions

  def create(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        IO.inspect(user)
        user_with_token = Sessions.user_with_token(user)
        {:ok, user_with_token}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
