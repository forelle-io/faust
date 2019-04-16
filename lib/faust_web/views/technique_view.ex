defmodule FaustWeb.TechniquesView do
  use FaustWeb, :view

  alias Faust.Fishing

  def techniques_for_multiple_select do
    Enum.map(Fishing.list_techniques(), &{&1.name, &1.id})
  end
end
