defmodule FaustWeb.WaterView do
  use FaustWeb, :view

  def resolve_select_id("modal", id), do: id

  def resolve_select_id(_from, id), do: "new_water_" <> id
end
