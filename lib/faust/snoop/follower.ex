defmodule Faust.Snoop.Follower do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Accounts.User

  @primary_key false

  schema "snoop.followers" do
    belongs_to(:users, User)
    belongs_to(:followers, User)
  end
end
