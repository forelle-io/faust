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
    test "когда контроль ресурсов пройден, подписка отсутствует в общем списке подписок",
         %{current_user: current_user} do
      other_user = insert(:accounts_user)

      assert {:ok, [other_user.id]} ==
               FollowerService.follower_create(current_user, [], other_user.id)
    end

    test "когда контроль ресурсов пройден, подписант присутствует в списке подписантов",
         %{current_user: current_user} do
      other_user = insert(:accounts_user)

      assert {:error, true} ==
               FollowerService.follower_create(current_user, [other_user.id], other_user.id)
    end

    test "когда контроль ресурсов не пройден, подписант отсутствует в списке подписантов",
         %{current_user: current_user} do
      assert {:error, {:error, :unauthorized}} ==
               FollowerService.follower_create(current_user, [], current_user.id)
    end

    test "когда контроль ресурсов не пройден, подписант присутствует в списке подписантов",
         %{current_user: current_user} do
      assert {:error, {:error, :unauthorized}} ==
               FollowerService.follower_create(current_user, [current_user.id], current_user.id)
    end
  end

  describe "follower_delete" do
    test "когда подписант существует, контроль ресурсов пройден, подписант присутствует в списке подписантов",
         %{current_user: current_user} do
      other_user = insert(:accounts_user)
      Snoop.create_follower(%{"user_id" => current_user.id, "follower_id" => other_user.id})

      assert {:ok, []} ==
               FollowerService.follower_delete(current_user, [other_user.id], other_user.id)
    end

    test "когда подписант существует, контроль ресурсов пройден, подписант отсутствует в списке подписантов",
         %{current_user: current_user} do
      other_user = insert(:accounts_user)
      Snoop.create_follower(%{"user_id" => current_user.id, "follower_id" => other_user.id})

      assert {:error, false} ==
               FollowerService.follower_delete(current_user, [], other_user.id)
    end

    test "когда подписант не существует",
         %{current_user: current_user} do
      assert {:error, nil} ==
               FollowerService.follower_delete(current_user, [], current_user.id + 1)
    end
  end
end
