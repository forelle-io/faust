defmodule FaustWeb.Snoop.FollowerHelper do
  @moduledoc false

  alias Faust.Snoop
  alias Faust.Snoop.Follower

  def follower_create(current_user, list_followee_ids, follower_id) do
    with :ok <- Bodyguard.permit(Follower, :create, current_user, follower_id),
         false <- Enum.member?(list_followee_ids, follower_id),
         {:ok, _follower} <-
           %{"user_id" => current_user.id, "follower_id" => follower_id}
           |> Snoop.create_follower() do
      {:ok, [follower_id] ++ list_followee_ids}
    else
      reason ->
        {:error, reason}
    end
  end

  def follower_delete(current_user, list_followee_ids, follower_id) do
    with %Follower{} = follower <-
           Snoop.get_follower_by(%{user_id: current_user.id, follower_id: follower_id}),
         :ok <- Bodyguard.permit(Follower, :delete, current_user, follower),
         {:ok, _follower} <- Snoop.delete_follower(follower) do
      {:ok, list_followee_ids -- [follower_id]}
    else
      reason ->
        {:error, reason}
    end
  end
end
