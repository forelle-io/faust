defmodule Faust.Snoop do
  @moduledoc """
  The Snoop context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  # Follower structure -------------------------------------------------------

  alias Faust.Snoop.Follower

  def list_followee_ids(user_id)
      when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> Follower.list_followee_ids_query()
    |> Repo.all()
  end

  def list_follower_ids(user_id)
      when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> Follower.list_follower_ids_query()
    |> Repo.all()
  end

  def count_user_followee(user_id)
      when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> Follower.count_user_followee_query()
    |> Repo.aggregate(:count, :user_id)
  end

  def count_user_followers(user_id) when is_integer(user_id) or is_bitstring(user_id) do
    user_id
    |> Follower.count_user_followers_query()
    |> Repo.aggregate(:count, :follower_id)
  end

  def get_follower_by(params) do
    Repo.get_by(Follower, params)
  end

  def create_follower(attrs \\ %{}) do
    %Follower{}
    |> Follower.changeset(attrs)
    |> Repo.insert()
  end

  def delete_follower(%Follower{} = follower) do
    Repo.delete(follower)
  end
end
