defmodule Faust.Support.FishesFixtures do
  @moduledoc false

  alias Faust.Fishing.Fish

  @fish_attrs %{
    name: "щука"
  }

  def fish_attrs, do: @fish_attrs

  def fish_fixture(attrs \\ %{}) do
    {:ok, %Fish{} = fish} =
      attrs
      |> Enum.into(@fish_attrs)
      |> Faust.Fishing.create_fish()

    fish
  end
end
