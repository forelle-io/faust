defmodule FaustWeb.Reservoir.HistoryPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  def authorize(_, _, _), do: false
end
