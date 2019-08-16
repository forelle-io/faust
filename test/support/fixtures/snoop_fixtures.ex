defmodule Faust.Support.SnoopFixtures do
  @moduledoc false

  alias Faust.Accounts.User
  alias Faust.Snoop.FollowerUser

  def follower_fixture(%User{} = user, %User{} = follower) do
    {:ok, %FollowerUser{} = follower} =
      %{"user_id" => user.id, "follower_id" => follower.id}
      |> Faust.Snoop.create_user_follower()

    follower
  end
end
