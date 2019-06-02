defmodule Faust.Reservoir.HistoryTest do
  @moduledoc false
  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.{AccountFixtures, ReservoirFixtures}

  alias Faust.Reservoir
  alias Faust.Reservoir.History

  describe "list_histories/0" do
    test "когда записи histories отсутствуют" do
      assert Reservoir.list_histories() |> Enum.empty?()
    end

    test "когда записи histories присутствуют в количестве 5" do
      insert_list(5, :reservoir_history)

      assert Reservoir.list_histories() |> length() == 5
    end
  end


  describe "list_histories/1" do
    test "когда записи истории присутвуют для водоема в количестве 5" do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      Enum.each(1..5, fn _ -> history_fixture(current_water) end)

      assert current_water.id |> Reservoir.list_histories() |> length() == 5
    end
  end

  describe "get_history!/1" do
    test "когда запись для истории отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Reservoir.get_history!(1)
      end
    end

    test "когда запись для истории присутствует" do
      %History{id: id} = insert(:reservoir_history)
      history = Reservoir.get_history!(id)

      assert history.id == id
    end
  end

  describe "create_history/1" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :reservoir_water
        |> insert()
        |> history_attrs()
        |> Map.merge(%{"type" => nil, "description" => nil})
        |> Reservoir.create_history()

      refute changeset.valid?

      assert errors[:type] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      assert {:ok, %History{}} =
               :reservoir_water
               |> insert()
               |> history_attrs()
               |> Reservoir.create_history()
    end
  end

  describe "update_history/2" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :reservoir_history
        |> insert()
        |> Reservoir.update_history(%{"type" => nil})

      refute changeset.valid?

      assert errors[:type] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      {:ok, history} =
        :reservoir_history
        |> insert()
        |> Reservoir.update_history(%{
          "type" => "создание",
          "description" => "Запуск 500 кг форели"
        })

      assert history.type == "создание"

      assert history.description == "Запуск 500 кг форели"
    end
  end

  describe "delete_history/1" do
    test "когда запись history присутствует" do
      history = insert(:reservoir_history)

      assert {:ok, %History{}} = Reservoir.delete_history(history)

      assert_raise Ecto.NoResultsError, fn ->
        Reservoir.get_history!(history.id)
      end
    end
  end

  describe "change_history/1" do
    test "когда запись history присутствует" do
      assert %Ecto.Changeset{} =
               :reservoir_history
               |> insert()
               |> Reservoir.change_history()
    end

    test "когда запись history отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} = Reservoir.change_history(%History{})

      errors
      |> Enum.filter(fn {k, _v} -> Enum.member?([:type, :description], k) end)
      |> Enum.each(fn {_k, v} -> assert v == {"can't be blank", [validation: :required]} end)
    end
  end
end
