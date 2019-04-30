defmodule FaustWeb.Reservoir.HistoryPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.ReservoirFixtures

  alias FaustWeb.Reservoir.HistoryPolicy

  setup do
    current_user = insert(:user)
    {:ok, current_user: current_user}
  end

  describe "new" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert HistoryPolicy.authorize(:new, current_user, water)
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute HistoryPolicy.authorize(:new, insert(:user), water)
    end
  end

  describe "create" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert HistoryPolicy.authorize(:create, current_user, water)
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute HistoryPolicy.authorize(:create, insert(:user), water)
    end
  end

  describe "delete" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert HistoryPolicy.authorize(:delete, current_user, water)
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute HistoryPolicy.authorize(:delete, insert(:user), water)
    end
  end
end
