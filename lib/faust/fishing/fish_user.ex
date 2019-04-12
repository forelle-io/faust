defmodule Faust.Fishing.FishUser do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Accounts.User
  alias Faust.Fishing.Fish

  @primary_key false

  schema "fishes_users" do
    belongs_to :user, User
    belongs_to :fish, Fish
  end
end
