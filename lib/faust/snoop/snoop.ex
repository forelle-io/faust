defmodule Faust.Snoop do
  @moduledoc """
  The Snoop context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  # Follower structure -------------------------------------------------------

  alias Faust.Snoop.Follower

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
