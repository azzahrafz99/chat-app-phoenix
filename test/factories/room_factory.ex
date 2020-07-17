defmodule Chatter.RoomFactory do
  defmacro __using__(_opts) do
    alias Chatter.Talk.Room
    alias FakerElixir, as: Faker

    quote do
      def room_factory do
        %Room{
          name: Faker.Lorem.word,
          description: Faker.Lorem.sentence
        }
      end
    end
  end
end

