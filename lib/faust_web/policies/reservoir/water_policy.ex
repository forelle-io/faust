defmodule FaustWeb.Reservoir.WaterPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water

  def authorize(:index, %User{id: id}, %{"user_id" => id}) do
    true
  end

  def authorize(action, %User{id: id}, %Water{user_id: id})
      when action in [:edit, :update, :delete] do
    true
  end

  def authorize(_, _, _), do: false
end
