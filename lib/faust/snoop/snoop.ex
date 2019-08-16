defmodule Faust.Snoop do
  @moduledoc """
  The Snoop context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  # FollowerUser structure -------------------------------------------------------

  alias Faust.Snoop.FollowerUser

  def list_user_followee_ids(user_id) when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerUser.list_followee_ids_query()
    |> Repo.all()
  end

  def list_user_follower_ids(user_id)
      when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerUser.list_follower_ids_query()
    |> Repo.all()
  end

  def count_user_followee(user_id)
      when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerUser.count_user_followee_query()
    |> Repo.aggregate(:count, :user_id)
  end

  def count_user_followers(user_id) when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerUser.followers_query()
    |> Repo.aggregate(:count, :follower_id)
  end

  def get_user_follower_by(params) do
    Repo.get_by(FollowerUser, params)
  end

  def create_user_follower(attrs \\ %{}) do
    %FollowerUser{}
    |> FollowerUser.changeset(attrs)
    |> Repo.insert()
  end

  def delete_user_follower(%FollowerUser{} = follower) do
    Repo.delete(follower)
  end

  # FollowerWater structure -------------------------------------------------------

  alias Faust.Snoop.FollowerWater

  def list_water_followee_ids(user_id) when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerWater.list_followee_ids_query()
    |> Repo.all()
  end

  def list_water_follower_ids(user_id)
      when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerWater.list_follower_ids_query()
    |> Repo.all()
  end

  def count_water_followers(user_id) when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> FollowerWater.followers_query()
    |> Repo.aggregate(:count, :follower_id)
  end

  def get_water_follower_by(params) do
    Repo.get_by(FollowerWater, params)
  end

  def create_water_follower(attrs \\ %{}) do
    %FollowerWater{}
    |> FollowerWater.changeset(attrs)
    |> Repo.insert()
  end

  def delete_water_follower(%FollowerWater{} = follower) do
    Repo.delete(follower)
  end
end
