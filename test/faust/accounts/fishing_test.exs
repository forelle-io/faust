# write there your test from notepad
defmodule Faust.FishingTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.{FishesFixtures, Factories}

  alias Faust.Fishing
  alias Faust.Fishing.Fish
  alias Faust.Repo

  describe "fishes" do
    test "list_fish/0 возврат всей рыбы" do
      insert_list(5, :fish)

      assert Fishing.list_fishes() |> length() == 5
    end

    test "get_fish!/1 возврат рыбы по переданному id" do
      fish = insert(:fish)

      with %Fish{id: id} <- Fishing.get_fish!(fish.id) do
        assert fish.id == id
      end
    end

    test "create fishe/1 с валидными данными создание рыбы" do
      {:ok, %Fish{} = fish} =
        fish_attrs()
        |> Fishing.create_fish()

      assert fish.name == "щука"
    end

    test "create_fishe/1 с невалидными данными возврат ошибочного changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Fishing.create_fish(%{name: nil})
    end

    test "update_fish/2 в валидными данными обновление рыбы" do
      fish = insert(:fish)

      assert {:ok, %Fish{} = fish} =
               Fishing.update_fish(fish, %{
                 name: "щука"
               })

      assert fish.name == "щука"
    end

    test "update_fish/2 с невалидными данными возврат ошибочного changeset" do
      fish = insert(:fish)

      assert {:error, %Ecto.Changeset{}} = Fishing.update_fish(fish, %{name: nil})
    end

    test "delete fish/1 удаление рыбы" do
      fish = insert(:fish)

      assert {:ok, %Fish{}} = Fishing.delete_fish(fish)
      assert_raise Ecto.NoResultsError, fn -> Fishing.get_fish!(fish.id) end
    end

    test "change_fish/1 возврат changeset рыбы" do
      fish = insert(:fish)

      assert %Ecto.Changeset{} = Fishing.change_fish(fish)
    end
  end
end
