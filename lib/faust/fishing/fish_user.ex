defmodule Faust.Fishing.FishUser do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Accounts.User
  alias Faust.Fishing.Fish

  @primary_key false

  schema "fishing.fishes_users" do
    belongs_to(:fishes, Fish, foreign_key: :fish_id)
    belongs_to(:users, User, foreign_key: :user_id)
  end
end
