defmodule FaustWeb.FishView do
  use FaustWeb, :view

  alias Faust.Fishing

  def fishes_for_multiple_select do
    Enum.map(Fishing.list_fishes(), &{&1.name, &1.id})
  end
end
