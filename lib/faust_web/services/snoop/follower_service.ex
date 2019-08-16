defmodule FaustWeb.Snoop.FollowerService do
  @moduledoc false

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water
  alias Faust.Snoop
  alias Faust.Snoop.{FollowerUser, FollowerWater}

  def follow(%User{id: user_id} = user, %User{id: structure_id} = structure) do
    with :ok <- Bodyguard.permit(FollowerUser, :create, user, structure),
         {:ok, _follower_water} <-
           %{"user_id" => user_id, "follower_id" => structure_id} |> Snoop.create_user_follower() do
      true
    else
      error -> error
    end
  end

  def follow(%User{id: user_id} = user, %Water{id: structure_id} = structure) do
    with :ok <- Bodyguard.permit(FollowerWater, :create, user, structure),
         {:ok, _follower_water} <-
           %{"user_id" => user_id, "follower_id" => structure_id} |> Snoop.create_water_follower() do
      true
    else
      error -> error
    end
  end

  def follow(_current_user, _structure), do: {:error, :unauthorized}

  def unfollow(%User{} = current_user, %FollowerUser{} = follower) do
    with :ok <- Bodyguard.permit(FollowerUser, :delete, current_user, follower),
         {:ok, _follower_user} <- Snoop.delete_user_follower(follower) do
      true
    else
      error -> error
    end
  end

  def unfollow(%User{} = current_user, %FollowerWater{} = follower) do
    with :ok <- Bodyguard.permit(FollowerWater, :delete, current_user, follower),
         {:ok, _follower_user} <- Snoop.delete_water_follower(follower) do
      true
    else
      error -> error
    end
  end

  def unfollow(_current_user, _follower), do: {:error, :unauthorized}
end
