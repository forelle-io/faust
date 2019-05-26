defmodule Faust.Fishing.FishTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.FishesFixtures, only: [fish_attrs: 0]

  alias Faust.Fishing
  alias Faust.Fishing.Fish

  describe "list_fishes/0" do
    test "когда записи fishes отсутствуют" do
      assert Fishing.list_fishes() |> Enum.empty?()
    end

    test "когда записи fishes присутствуют в количестве 5" do
      insert_list(5, :fishing_fish)

      assert Fishing.list_fishes() |> length() == 5
    end
  end

  describe "list_fishes/1" do
    test "когда записи fishes отсутствуют в количестве 5 со списоком ids" do
      assert [] |> Fishing.list_fishes() |> Enum.empty?()
    end

    test "когда записи fishes присутствуют в количестве 5 с пустым списоком ids" do
      list_fishes = insert_list(5, :fishing_fish)

      assert list_fishes |> Enum.map(& &1.id) |> Fishing.list_fishes() == list_fishes
    end
  end

  describe "get_fish!/1" do
    test "когда запись fish отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Fishing.get_fish!(1)
      end
    end

    test "когда запись fish присутствует" do
      %Fish{id: id} = insert(:fishing_fish)
      fish = Fishing.get_fish!(id)

      assert fish.id == id
    end
  end

  describe "create_fish/1" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        fish_attrs()
        |> Map.merge(%{"name" => nil})
        |> Fishing.create_fish()

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      assert {:ok, %Fish{}} = fish_attrs() |> Fishing.create_fish()
    end
  end

  describe "create_fish!/1" do
    test "когда данные не валидны" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        fish_attrs()
        |> Map.merge(%{"name" => nil})
        |> Fishing.create_fish!()
      end
    end

    test "когда данные валидны" do
      assert %Fish{} = fish_attrs() |> Fishing.create_fish!()
    end
  end

  describe "update_fish/2" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :fishing_fish
        |> insert()
        |> Fishing.update_fish(%{"name" => nil})

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      {:ok, fish} =
        :fishing_fish
        |> insert()
        |> Fishing.update_fish(%{"name" => "форель"})

      assert fish.name == "форель"
    end
  end

  describe "delete_fish/1" do
    test "когда запись fish присутствует" do
      fish = insert(:fishing_fish)

      assert {:ok, %Fish{}} = Fishing.delete_fish(fish)

      assert_raise Ecto.NoResultsError, fn ->
        Fishing.get_fish!(fish.id)
      end
    end
  end

  describe "change_fish/1" do
    test "когда запись fish присутствует" do
      assert %Ecto.Changeset{} =
               :fishing_fish
               |> insert()
               |> Fishing.change_fish()
    end

    test "когда запись fish отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} = Fishing.change_fish(%Fish{})

      assert errors[:name] == {"can't be blank", [validation: :required]}
    end
  end
end
