defmodule Chatter.Talk.Message do
  use Ecto.Schema
  use Timex

  import Ecto.Changeset

  schema "messages" do
    field :body, :string

    belongs_to :room, Chatter.Talk.Room
    belongs_to :user, Chatter.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end

  def date(message) do
    require IEx; IEx.pry
    Timex.from_now(message.inserted_at)
  end
end
