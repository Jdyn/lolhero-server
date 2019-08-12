defmodule LolHero.Services.Sessions do
  import Bcrypt, only: [check_pass: 2]

  alias LolHero.User
  alias LolHero.Auth.Guardian

  def refresh(token) do
    case Guardian.refresh(token) do
      {:ok, _old_stuff, {new_token, new_claims}} ->
        case Guardian.resource_from_claims(new_claims) do
          {:ok, user} ->
            user_with_token = Map.put(user, :token, new_token)

            {:ok, user_with_token}

          {:error, reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def authenticate(%{"username" => username, "password" => password}) do
    error = {:error, "Username or password is incorrect."}

    case User.find_by(username: username) do
      nil ->
        error

      user ->
        case check_pass(user, password) do
          {:error, _} ->
            error

          {:ok, user} ->
            {:ok, user_with_token(user)}
        end
    end
  end

  def authenticate(params), do: {:error, "Username and password fields required."}

  def user_with_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    Map.put(user, :token, token)
  end
end
