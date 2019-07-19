defmodule FaustWeb.Snoop.FollowerService do
  @moduledoc false

  alias Faust.Snoop
  alias Faust.Snoop.Follower

  def follower_create(current_user, follower_id) do
    with :ok <- Bodyguard.permit(Follower, :create, current_user, follower_id),
         {:ok, _follower} <-
           %{"user_id" => current_user.id, "follower_id" => follower_id}
           |> Snoop.create_follower() do
      :ok
    else
      reason ->
        {:error, reason}
    end
  end

  def follower_delete(current_user, follower_id) do
    with %Follower{} = follower <-
           Snoop.get_follower_by(%{user_id: current_user.id, follower_id: follower_id}),
         :ok <- Bodyguard.permit(Follower, :delete, current_user, follower),
         {:ok, _follower} <- Snoop.delete_follower(follower) do
      :ok
    else
      reason ->
        {:error, reason}
    end
  end
end
