defmodule FaustWeb.Snoop.FollowerUserPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User
  alias Faust.Snoop.FollowerUser

  def authorize(:create, %User{id: id}, %User{id: id}), do: false

  def authorize(:create, %User{}, _follow_user_id), do: true

  def authorize(:delete, %User{id: id}, %FollowerUser{user_id: id}), do: true

  def authorize(_, _, _), do: false
end
