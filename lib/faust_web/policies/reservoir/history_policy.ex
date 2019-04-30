defmodule FaustWeb.Reservoir.HistoryPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water

  def authorize(action, %User{id: id}, %Water{user_id: id})
      when action in [:new, :create, :delete] do
    true
  end

  def authorize(_, _, _), do: false
end
