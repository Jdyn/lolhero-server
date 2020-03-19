defmodule LolHero.Message do
  use LolHero.Web, :model

  alias LolHero.{Repo, Message, User, Order}

  schema "messages" do
    field(:message, :string)
    belongs_to(:user, User)
    belongs_to(:order, Order)

    timestamps()
  end

  def create(attrs) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(%Message{} = message, attrs) do
    message
    |> changeset(attrs)
    |> Repo.update()
  end

  def find(id) do
    Message
    |> Repo.get(id)
    |> Repo.preload(:user)
  end

  def find_all(order_id) do
    query =
      from(message in Message,
        where: message.order_id == ^order_id,
        preload: [:user],
        select: message
      )

    Repo.all(query)
  end

  def delete(%Message{} = message) do
    message
    |> Repo.delete()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :user_id, :order_id])
    |> validate_required([:message, :user_id, :order_id])
  end
end
