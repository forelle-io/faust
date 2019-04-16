defmodule Faust.FishingTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.{FishesFixtures, Factories}

  alias Faust.Fishing
  alias Faust.Fishing.{Fish, Technique}

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

    test "create fishe/1 с валидными данными создания рыбы" do
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
                 name: "окунь"
               })

      assert fish.name == "окунь"
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

  describe "technique" do
    test "list_technique/0 возврат всей техники ловли" do
      insert_list(5, :technique)

      assert Fishing.list_techniques() |> length() == 5
    end

    test "get_technique!/1 возврат техники ловли по переданному id " do
      technique = insert(:technique)

      with %Technique{id: id} <- Fishing.get_technique!(technique.id) do
        assert technique.id == id
      end
    end

    test "create_technique/1 с валидными данными" do
      {:ok, %Technique{} = technique} =
        technique_attrs()
        |> Fishing.create_technique()

      assert technique.name == "троллинг"
      assert technique.description == "описание троллинга"
    end

    test "create_technique/1 с невалидными данными воврат ошибочного changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Fishing.create_technique(%{name: nil, description: nil})
    end

    test "update_technique/2 с валидными данными обнволения техники ловли" do
      technique = insert(:technique)

      assert {:ok, %Technique{} = technique} =
               Fishing.update_technique(technique, %{
                 name: "спиннинг",
                 description: "описание спиннинга"
               })

      assert technique.name == "спиннинг"
      assert technique.description == "описание спиннинга"
    end

    test "update_technique/2 с невалидными данными воврат ошибочного changeset" do
      technique = insert(:technique)

      assert {:ok, %Technique{}} = Fishing.delete_technique(technique)

      assert {:error, %Ecto.Changeset{}} =
               Fishing.update_technique(technique, %{name: nil, description: nil})
    end

    test "delete_technique/1 удаление техники ловли" do
      technique = insert(:technique)

      assert {:ok, %Technique{}} = Fishing.delete_technique(technique)
      assert_raise Ecto.NoResultsError, fn -> Fishing.get_technique!(technique.id) end
    end

    test "change_technique/1 returns a technique changeset" do
      technique = insert(:technique)

      assert %Ecto.Changeset{} = Fishing.change_technique(technique)
    end
  end
end
