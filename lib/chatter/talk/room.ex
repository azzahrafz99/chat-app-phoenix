defmodule Chatter.Talk.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatter.Talk.Room

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :topic, :string
    belongs_to :user, Chatter.Accounts.User
    has_many :messages, Chatter.Talk.Message

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :description, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 5, max: 30)
    |> validate_length(:topic, min: 5, max: 120)
  end
end
