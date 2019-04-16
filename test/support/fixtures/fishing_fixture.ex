defmodule Faust.Support.FishesFixtures do
  @moduledoc false

  alias Faust.Fishing.{Fish, Technique}

  @fish_attrs %{
    name: "щука"
  }

  @technique_attrs %{
    name: "троллинг",
    description: "описание троллинга"
  }

  def fish_attrs, do: @fish_attrs

  def technique_attrs, do: @technique_attrs

  def fish_fixture(attrs \\ %{}) do
    {:ok, %Fish{} = fish} =
      attrs
      |> Enum.into(@fish_attrs)
      |> Faust.Fishing.create_fish()

    fish
  end

  def technique_fixture(attrs \\ %{}) do
    {:ok, %Technique{} = technique} =
      attrs
      |> Enum.into(@technique_attrs)
      |> Faust.Fishing.create_technique()

    technique
  end
end
