defmodule FaustWeb.Snoop.FollowerPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User
  alias Faust.Snoop.Follower

  def authorize(:create, %User{id: id}, follower_id) do
    case follower_id do
      ^id -> false
      _ -> true
    end
  end

  def authorize(:delete, %User{id: id}, %Follower{user_id: id}) do
    true
  end

  def authorize(_, _, _), do: false
end
