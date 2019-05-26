defmodule Faust.Accounts.ChiefTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.AccountFixtures, only: [chief_attrs: 0]

  alias Faust.Accounts
  alias Faust.Accounts.Chief

  describe "list_chiefs/0" do
    test "когда записи chiefs отсутствуют" do
      assert Accounts.list_chiefs() |> Enum.empty?()
    end

    test "когда записи chiefs присутствуют в количестве 5" do
      insert_list(5, :accounts_chief)

      assert Accounts.list_chiefs() |> length() == 5
    end
  end

  describe "get_chief!/1" do
    test "когда запись chief отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_chief!(1)
      end
    end

    test "когда запись chief присутствует" do
      %Chief{id: id} = insert(:accounts_chief)
      chief = Accounts.get_chief!(id)

      assert chief.id == id
    end
  end

  describe "get_chief/1" do
    test "когда запись chief отсутствует" do
      refute Accounts.get_chief(1)
    end

    test "когда запись chief присутствует" do
      %Chief{id: id} = insert(:accounts_chief)
      chief = Accounts.get_chief(id)

      assert chief.id == id
    end
  end

  describe "create_chief/1" do
    test "когда данные валидны" do
      assert {:ok, %Chief{}} = chief_attrs() |> Accounts.create_chief()
    end
  end

  describe "update_chief/2" do
    test "когда данные валидны" do
      assert {:ok, chief} =
               :accounts_chief
               |> insert()
               |> Accounts.update_chief(%{})
    end
  end
end
