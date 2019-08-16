defmodule Faust.Snoop.FollowerUser do
  @moduledoc false

  use Faust.Snoop.MutualOptionals, module_name: __MODULE__

  alias __MODULE__
  alias Faust.Accounts.User
  alias FaustWeb.Snoop.FollowerUserPolicy

  @primary_key false

  schema "snoop.follower_users" do
    belongs_to :users, User, foreign_key: :user_id, primary_key: true
    belongs_to :followers, User, foreign_key: :follower_id, primary_key: true
  end

  defdelegate authorize(action, current_user, resource), to: FollowerUserPolicy

  # Changesets -----------------------------------------------------------------

  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
    |> unique_constraint(:"snoop.followers_pkey", name: :"snoop.followers_pkey")
  end

  # SQL запросы ----------------------------------------------------------------

  def count_user_followee_query(user_id) do
    from f in FollowerUser,
      where: f.user_id == ^user_id
  end
end
