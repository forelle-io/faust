defmodule Faust.Reservoir.WaterTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.ReservoirFixtures

  alias Faust.Accounts.User
  alias Faust.Reservoir
  alias Faust.Reservoir.Water

  describe "list_waters/0" do
    test "когда записи waters отсутствуют" do
      assert Reservoir.list_waters() |> Enum.empty?()
    end

    test "когда записи waters присутствуют в количестве 5" do
      insert_list(5, :reservoir_water)

      assert Reservoir.list_waters() |> length() == 5
    end
  end

  describe "list_waters/1" do
    test "когда записи waters присутствуют в количестве 5 с пустой предзагрузкой" do
      insert_list(5, :reservoir_water)
      assert Reservoir.list_waters([]) |> length() == 5
    end

    test "когда записи users присутствуют в количестве 5 с предзагрузкой user" do
      insert_list(5, :reservoir_water)
      list_waters = Reservoir.list_waters([:user])

      assert length(list_waters) == 5

      assert Enum.all?(list_waters, fn water ->
               case water do
                 %Water{user: %User{}} ->
                   true

                 _ ->
                   false
               end
             end)
    end
  end

  describe "list_waters/2" do
    test "когда записи пользователя отсутствуют с пустой предзагрузкой" do
      user = insert(:accounts_user)

      assert user.id |> Reservoir.list_waters([]) |> Enum.empty?()
    end

    test "когда записи пользователя отсутствуют с предзагрузкой user" do
      user = insert(:accounts_user)

      assert user.id |> Reservoir.list_waters([:user]) |> Enum.empty?()
    end

    test "когда записи пользователя присутствуют с пустой предзагрузкой" do
      user = insert(:accounts_user)
      Enum.each(1..5, fn _ -> water_fixture(user) end)

      assert user.id |> Reservoir.list_waters([]) |> length() == 5
    end

    test "когда записи пользователя присутствуют с предзагрузкой user" do
      user = insert(:accounts_user)
      Enum.each(1..5, fn _ -> water_fixture(user) end)

      list_waters = Reservoir.list_waters(user.id, [:user])

      assert Enum.all?(list_waters, fn water ->
               case water do
                 %Water{user: %User{}} ->
                   true

                 _ ->
                   false
               end
             end)
    end
  end

  describe "get_water!/1" do
    test "когда запись water отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Reservoir.get_water!(1)
      end
    end

    test "когда запись water присутствует" do
      %Water{id: id} = insert(:reservoir_water)
      water = Reservoir.get_water!(id)

      assert water.id == id
    end
  end

  describe "create_water/1" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :accounts_user
        |> insert()
        |> water_attrs()
        |> Map.merge(%{"name" => nil, "description" => nil})
        |> Reservoir.create_water()

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:description] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      assert {:ok, %Water{}} =
               :accounts_user
               |> insert()
               |> water_attrs()
               |> Reservoir.create_water()
    end
  end

  describe "update_water/2" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :reservoir_water
        |> insert()
        |> Reservoir.update_water(%{"name" => nil, "description" => nil})

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:description] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      {:ok, water} =
        :reservoir_water
        |> insert()
        |> Reservoir.update_water(%{
          "name" => "Большой сом",
          "description" =>
            "Только здоровая рыба, выращенная в естественных условиях на природных кормах."
        })

      assert water.name == "Большой сом"

      assert water.description ==
               "Только здоровая рыба, выращенная в естественных условиях на природных кормах."
    end
  end

  describe "delete_water/1" do
    test "когда запись water присутствует" do
      water = insert(:reservoir_water)

      assert {:ok, %Water{}} = Reservoir.delete_water(water)

      assert_raise Ecto.NoResultsError, fn ->
        Reservoir.get_water!(water.id)
      end
    end
  end

  describe "change_water/1" do
    test "когда запись water присутствует" do
      assert %Ecto.Changeset{} =
               :reservoir_water
               |> insert()
               |> Reservoir.change_water()
    end

    test "когда запись water отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} = Reservoir.change_water(%Water{})

      errors
      |> Enum.filter(fn {k, _v} -> Enum.member?([:name, :description, :is_frozen], k) end)
      |> Enum.each(fn {_k, v} -> assert v == {"can't be blank", [validation: :required]} end)
    end
  end
end
