defmodule Faust.Fishing.FishUser do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Accounts.User
  alias Faust.Fishing.Fish

  @primary_key false

  schema "fishing.fishes_users" do
    belongs_to(:fishes, Fish)
    belongs_to(:users, User)
  end
end
