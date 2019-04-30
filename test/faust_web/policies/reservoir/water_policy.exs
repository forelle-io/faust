defmodule FaustWeb.Reservoir.WaterPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.ReservoirFixture

  alias FaustWeb.Reservoir.WaterPolicy

  setup do
    current_user = insert(:user)
    {:ok, current_user: current_user}
  end

  describe "index" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert WaterPolicy.authorize(:index, current_user, %{"user_id" => water.user_id})
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute WaterPolicy.authorize(:index, insert(:user), %{"user_id" => water.user_id})
    end
  end

  describe "edit" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert WaterPolicy.authorize(:edit, current_user, water)
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute WaterPolicy.authorize(:edit, insert(:user), water)
    end
  end

  describe "update" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert WaterPolicy.authorize(:update, current_user, water)
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute WaterPolicy.authorize(:update, insert(:user), water)
    end
  end

  describe "delete" do
    test "разрешено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      assert WaterPolicy.authorize(:delete, current_user, water)
    end

    test "запрещено", %{current_user: current_user} do
      water = water_fixture(%{"user" => current_user})
      refute WaterPolicy.authorize(:delete, insert(:user), water)
    end
  end
end
