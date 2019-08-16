defmodule FaustWeb.Snoop.FollowerServiceTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.Factories

  alias Faust.Snoop
  alias FaustWeb.Snoop.FollowerService

  setup do
    {:ok, current_user: insert(:accounts_user)}
  end

  describe "follower_create" do
    test "когда подписант существует, контроль ресурсов пройден",
         %{current_user: current_user} do
      other_user = insert(:accounts_user)

      assert FollowerService.follow(current_user, other_user)
    end

    test "когда подписант не существует",
         %{current_user: current_user} do
      assert {:error, :unauthorized} == FollowerService.follow(current_user, current_user)
    end
  end

  describe "follower_delete" do
    test "когда подписант существует, контроль ресурсов пройден",
         %{current_user: current_user} do
      other_user = insert(:accounts_user)

      {:ok, user_follower} =
        Snoop.create_user_follower(%{"user_id" => current_user.id, "follower_id" => other_user.id})

      assert FollowerService.unfollow(current_user, user_follower)
    end

    test "когда подписант не существует", %{current_user: current_user} do
      assert {:error, :unauthorized} == FollowerService.unfollow(current_user, nil)
    end
  end
end
