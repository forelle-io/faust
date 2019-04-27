defmodule Faust.Fishing.FishUser do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Fishing.Fish
  alias Faust.Accounts.User

  @primary_key false

  schema "fishing.fishes_users" do
    belongs_to(:fishes, Fish)
    belongs_to(:users, User)
  end
end
