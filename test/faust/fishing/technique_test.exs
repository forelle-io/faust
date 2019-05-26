defmodule Faust.Fishing.TechniqueTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.FishesFixtures, only: [technique_attrs: 0]

  alias Faust.Fishing
  alias Faust.Fishing.Technique

  describe "list_techniques/0" do
    test "когда записи techniques отсутствуют" do
      assert Fishing.list_techniques() |> Enum.empty?()
    end

    test "когда записи techniques присутствуют в количестве 5" do
      insert_list(5, :fishing_technique)

      assert Fishing.list_techniques() |> length() == 5
    end
  end

  describe "list_techniques/1" do
    test "когда записи techniques отсутствуют в количестве 5 со списоком ids" do
      assert [] |> Fishing.list_techniques() |> Enum.empty?()
    end

    test "когда записи techniques присутствуют в количестве 5 с пустым списоком ids" do
      list_techniques = insert_list(5, :fishing_technique)

      assert list_techniques |> Enum.map(& &1.id) |> Fishing.list_techniques() == list_techniques
    end
  end

  describe "get_technique!/1" do
    test "когда запись technique отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Fishing.get_technique!(1)
      end
    end

    test "когда запись technique присутствует" do
      %Technique{id: id} = insert(:fishing_technique)
      technique = Fishing.get_technique!(id)

      assert technique.id == id
    end
  end

  describe "create_technique/1" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        technique_attrs()
        |> Map.merge(%{"name" => nil})
        |> Fishing.create_technique()

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      assert {:ok, %Technique{}} = technique_attrs() |> Fishing.create_technique()
    end
  end

  describe "create_technique!/1" do
    test "когда данные не валидны" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        technique_attrs()
        |> Map.merge(%{"name" => nil})
        |> Fishing.create_technique!()
      end
    end

    test "когда данные валидны" do
      assert %Technique{} = technique_attrs() |> Fishing.create_technique!()
    end
  end

  describe "update_technique/2" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :fishing_technique
        |> insert()
        |> Fishing.update_technique(%{"name" => nil})

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      {:ok, technique} =
        :fishing_technique
        |> insert()
        |> Fishing.update_technique(%{"name" => "поплавочная удочка"})

      assert technique.name == "поплавочная удочка"
    end
  end

  describe "delete_technique/1" do
    test "когда запись technique присутствует" do
      technique = insert(:fishing_technique)

      assert {:ok, %Technique{}} = Fishing.delete_technique(technique)

      assert_raise Ecto.NoResultsError, fn ->
        Fishing.get_technique!(technique.id)
      end
    end
  end

  describe "change_technique/1" do
    test "когда запись technique присутствует" do
      assert %Ecto.Changeset{} =
               :fishing_technique
               |> insert()
               |> Fishing.change_technique()
    end

    test "когда запись technique отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} =
               Fishing.change_technique(%Technique{})

      assert errors[:name] == {"can't be blank", [validation: :required]}
    end
  end
end
