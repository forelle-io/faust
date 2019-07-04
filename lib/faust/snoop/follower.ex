defmodule Faust.Snoop.Follower do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Faust.Accounts.User
  alias FaustWeb.Snoop.FollowerPolicy

  @primary_key false

  schema "snoop.followers" do
    belongs_to :users, User, foreign_key: :user_id, primary_key: true
    belongs_to :followers, User, foreign_key: :follower_id, primary_key: true
  end

  defdelegate authorize(action, current_user, resource), to: FollowerPolicy

  # Changesets -----------------------------------------------------------------

  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
    |> unique_constraint(:"snoop.followers_pkey", name: :"snoop.followers_pkey")
  end

  # SQL запросы ----------------------------------------------------------------

  def list_followee_ids_query(user_id) do
    from f in Follower,
      select: f.follower_id,
      where: f.user_id == ^user_id
  end

  def list_follower_ids_query(user_id) do
    from f in Follower,
      select: f.follower_id,
      where: f.follower_id == ^user_id
  end

  def count_user_followee_query(user_id) do
    from f in Follower,
      where: f.user_id == ^user_id
  end

  def count_user_followers_query(user_id) do
    from f in Follower,
      where: f.follower_id == ^user_id
  end
end
