defmodule Chatter.Factory do
  use ExMachina.Ecto, repo: Chatter.Repo
  use Chatter.RoomFactory
end

