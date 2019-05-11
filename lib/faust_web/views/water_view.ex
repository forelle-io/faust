defmodule FaustWeb.WaterView do
  use FaustWeb, :view

  alias Faust.Reservoir.Water

  def colors_for_select do
    Water.colors() |> Map.keys()
  end

  def prepare_color(type) do
    case type do
      "коричневый" -> "#CD853F"
      "зеленый" -> "#008000"
      _ -> "#00FFFF"
    end
  end
end
