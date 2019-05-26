defmodule Faust.Support.SnoopFixtures do
  @moduledoc false

  alias Faust.Accounts.User
  alias Faust.Snoop.Follower

  def follower_fixture(%User{} = user, %User{} = follower) do
    {:ok, %Follower{} = follower} =
      %{"user_id" => user.id, "follower_id" => follower.id}
      |> Faust.Snoop.create_follower()

    follower
  end
end
