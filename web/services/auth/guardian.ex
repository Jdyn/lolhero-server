defmodule LolHero.Auth.Guardian do
  use Guardian, otp_app: :LolHero

  alias LolHero.User

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    case User.find(claims["sub"]) do
      nil ->
        {:error, "resource_not_found"}

      user ->
        {:ok, user}
    end
  end
end
