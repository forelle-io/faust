defmodule FaustWeb.Policies.Snoop.FollowerPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories, only: [insert: 1]
  import Faust.Support.SnoopFixtures

  alias FaustWeb.Snoop.FollowerPolicy

  setup do
    {:ok, current_user: insert(:accounts_user)}
  end

  describe "create" do
    test "разрешение, когда ресурсом не является id текущей структуры user", %{
      current_user: current_user
    } do
      assert FollowerPolicy.authorize(:create, current_user, current_user.id + 1)
    end

    test "запрет, когда ресурсом является id текущей структуры user", %{
      current_user: current_user
    } do
      refute FollowerPolicy.authorize(:create, current_user, current_user.id)
    end
  end

  describe "delete" do
    test "разрешение, когда ресурсом является структура follower, в которой user_id - текущая структура user",
         %{
           current_user: current_user
         } do
      follower = follower_fixture(current_user, insert(:accounts_user))
      assert FollowerPolicy.authorize(:delete, current_user, follower)
    end

    test "запрет, когда ресурсом является структура follower, в которой user_id - не текущая структура user",
         %{
           current_user: current_user
         } do
      follower = follower_fixture(insert(:accounts_user), current_user)
      refute FollowerPolicy.authorize(:delete, current_user, follower)
    end
  end
end
