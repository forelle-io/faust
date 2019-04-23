defmodule Faust.Support.ReservoirFixtures do
  @moduledoc false

  alias Faust.Reservoir.Water

  @water_attrs %{
    "name" => "Золотой карась",
    "description" => "Описание водоема",
    "is_frozen" => true
  }

  def water_attrs, do: @water_attrs

  def water_fixture(attrs \\ %{}) do
    {:ok, %Water{} = water} =
      attrs
      |> Enum.into(@water_attrs)
      |> Faust.Reservoir.create_water()

    water
  end
end
