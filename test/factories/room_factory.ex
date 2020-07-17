defmodule Chatter.RoomFactory do
  defmacro __using__(_opts) do
    alias Chatter.Talk.Room

    quote do
      def room_factory do
        %Room{
          name: "My awesome article!",
          description: "Still working on it!"
        }
      end
    end
  end
end

