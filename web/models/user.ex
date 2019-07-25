defmodule LolHero.User do
  use LolHero.Web, :model

  import Comeonin.Bcrypt, only: [add_hash: 1]

  alias LolHero.{User, Regexp, Repo, Order}

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:age, :integer)
    field(:avatar, :string)

    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:token, :string, virtual: true)

    field(:is_admin, :boolean, default: false)

    has_many(:orders, Order, on_delete: :delete_all)

    timestamps()
  end

  def find(id) do
    Repo.get(User, id)
  end

  def find_all() do
    Repo.all(User)
  end

  def find_by(param) do
    Repo.get_by(User, param)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> admin_changeset(attrs)
    |> Repo.update()
  end

  def admin_changeset(user, attrs) do
    user
    |> cast(attrs, [:is_admin])
  end

  
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :first_name, :last_name, :age, :password])
    |> validate_required([:username, :password])
    |> validate_format(:username, Regexp.username())
    |> validate_format(:email, Regexp.email())
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:username, min: 3, max: 16)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> hash_password
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, add_hash(password))

      _ ->
        changeset
    end
  end
end
