defmodule FaustWeb.Policies.Reservoir.HistoryPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories, only: [insert: 1]
  import Faust.Support.ReservoirFixtures, only: [water_fixture: 1]

  alias FaustWeb.Reservoir.HistoryPolicy

  setup do
    {:ok, current_user: insert(:accounts_user)}
  end

  describe "new" do
    test "разрешение, когда ресурсом является структура water, пренадлежащая текущей структуре user",
         %{
           current_user: current_user
         } do
      water = water_fixture(current_user)

      assert HistoryPolicy.authorize(:new, current_user, water)
    end

    test "запрет, когда ресурсом является структура water, принадлежащая другой структуре user",
         %{
           current_user: current_user
         } do
      water =
        :accounts_user
        |> insert()
        |> water_fixture()

      refute HistoryPolicy.authorize(:new, current_user, water)
    end
  end

  describe "create" do
    test "разрешение, когда ресурсом является структура water, пренадлежащая текущей структуре user",
         %{
           current_user: current_user
         } do
      water = water_fixture(current_user)

      assert HistoryPolicy.authorize(:create, current_user, water)
    end

    test "запрет, когда ресурсом является структура water, принадлежащая другой структуре user",
         %{
           current_user: current_user
         } do
      water =
        :accounts_user
        |> insert()
        |> water_fixture()

      refute HistoryPolicy.authorize(:create, current_user, water)
    end
  end

  describe "delete" do
    test "разрешение, когда ресурсом является структура water, пренадлежащая текущей структуре user",
         %{
           current_user: current_user
         } do
      water = water_fixture(current_user)

      assert HistoryPolicy.authorize(:delete, current_user, water)
    end

    test "запрет, когда ресурсом является структура water, принадлежащая другой структуре user",
         %{
           current_user: current_user
         } do
      water =
        :accounts_user
        |> insert()
        |> water_fixture()

      refute HistoryPolicy.authorize(:delete, current_user, water)
    end
  end
end
