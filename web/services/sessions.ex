defmodule LolHero.Services.Sessions do
  alias LolHero.User
  alias Comeonin.Bcrypt
  alias LolHero.Auth.Guardian

  def refresh(token) do
    case Guardian.refresh(token) do
      {:ok, _old_stuff, {new_token, _new_claims}} ->
        {:ok, new_token}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def authenticate(params) do
    error = {:error, "Username or password is incorrect."}

    case User.find_by(username: params["username"]) do
      nil ->
        error

      user ->
        case Bcrypt.check_pass(user, params["password"]) do
          {:error, _} ->
            error

					{:ok, user} ->
            {:ok, user_with_token(user)}
        end
    end
  end

  def user_with_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    Map.put(user, :token, token)
	end
	
end
