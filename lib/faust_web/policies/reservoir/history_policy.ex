defmodule FaustWeb.Reservoir.HistoryPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water

  def authorize(:new, %User{id: id}, %Water{user_id: id}) do
    true
  end

  def authorize(_, _, _), do: false
end
