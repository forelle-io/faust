defmodule Faust.Snoop.FollowerWater do
  @moduledoc false

  use Faust.Snoop.MutualOptionals, module_name: __MODULE__

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water
  alias FaustWeb.Snoop.FollowerWaterPolicy

  @primary_key false

  schema "snoop.follower_waters" do
    belongs_to :users, User, foreign_key: :user_id, primary_key: true
    belongs_to :followers, Water, foreign_key: :follower_id, primary_key: true
  end

  defdelegate authorize(action, current_user, resource), to: FollowerWaterPolicy

  # Changesets -----------------------------------------------------------------

  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
  end
end
