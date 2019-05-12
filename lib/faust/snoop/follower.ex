defmodule Faust.Snoop.Follower do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Faust.Accounts.User

  @primary_key false

  schema "snoop.followers" do
    belongs_to :users, User, foreign_key: :user_id, primary_key: true
    belongs_to :followers, User, foreign_key: :follower_id, primary_key: true
  end

  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
    |> unique_constraint(:"snoop.followers_pkey", name: :"snoop.followers_pkey")
  end
end
