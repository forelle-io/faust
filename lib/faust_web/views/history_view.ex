defmodule FaustWeb.HistoryView do
  use FaustWeb, :view

  def types_select do
    Faust.Reservoir.History.types()
  end
end
