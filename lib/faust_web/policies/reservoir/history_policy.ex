defmodule FaustWeb.Reservoir.HistoryPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.{Chief, Organization}
  alias Faust.Reservoir.Water

  def authorize(_, _, _), do: false
end
