defmodule FaustWeb.HistoryView do
  use FaustWeb, :view

  alias Faust.Reservoir.History

  def types_select, do: History.types()
end
