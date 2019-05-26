defmodule FaustWeb.Policies.Reservoir.WaterPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories, only: [insert: 1]
  import Faust.Support.ReservoirFixtures, only: [water_fixture: 1]

  alias FaustWeb.Reservoir.WaterPolicy

  setup do
    {:ok, current_user: insert(:accounts_user)}
  end

  describe "index" do
    test "разрешение, когда ресурсом является карта с текущим user_id", %{
      current_user: current_user
    } do
      assert WaterPolicy.authorize(:index, current_user, %{"user_id" => current_user.id})
    end

    test "запрет, когда ресурсом является карта с другим user_id", %{current_user: current_user} do
      refute WaterPolicy.authorize(:index, current_user, %{"user_id" => current_user.id + 1})
    end
  end

  describe "edit" do
    test "разрешение, когда ресурсом является структура water, пренадлежащая текущей структуре user",
         %{
           current_user: current_user
         } do
      water = water_fixture(current_user)

      assert WaterPolicy.authorize(:edit, current_user, water)
    end

    test "запрет, когда ресурсом является структура water, принадлежащая другой структуре user",
         %{
           current_user: current_user
         } do
      water =
        :accounts_user
        |> insert()
        |> water_fixture()

      refute WaterPolicy.authorize(:edit, current_user, water)
    end
  end

  describe "update" do
    test "разрешение, когда ресурсом является структура water, пренадлежащая текущей структуре user",
         %{
           current_user: current_user
         } do
      water = water_fixture(current_user)

      assert WaterPolicy.authorize(:update, current_user, water)
    end

    test "запрет, когда ресурсом является структура water, принадлежащая другой структуре user",
         %{
           current_user: current_user
         } do
      water =
        :accounts_user
        |> insert()
        |> water_fixture()

      refute WaterPolicy.authorize(:update, current_user, water)
    end
  end

  describe "delete" do
    test "разрешение, когда ресурсом является структура water, пренадлежащая текущей структуре user",
         %{
           current_user: current_user
         } do
      water = water_fixture(current_user)

      assert WaterPolicy.authorize(:delete, current_user, water)
    end

    test "запрет, когда ресурсом является структура water, принадлежащая другой структуре user",
         %{
           current_user: current_user
         } do
      water =
        :accounts_user
        |> insert()
        |> water_fixture()

      refute WaterPolicy.authorize(:delete, current_user, water)
    end
  end
end
