defmodule FaustWeb.Snoop.FollowerWaterPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water
  alias Faust.Snoop.FollowerWater

  def authorize(:create, %User{id: id}, %Water{user_id: id}), do: false

  def authorize(:create, %User{}, %Water{}), do: true

  def authorize(:delete, %User{id: id}, %FollowerWater{user_id: id}), do: true

  def authorize(_, _, _), do: false
end
