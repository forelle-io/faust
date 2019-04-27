defmodule Faust.ReservoirTest do
  use Faust.DataCase

  alias Faust.Reservoir

  describe "history" do
    alias Faust.Reservoir.History

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def history_fixture(attrs \\ %{}) do
      {:ok, history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reservoir.create_history()

      history
    end

    test "list_history/0 returns all history" do
      history = history_fixture()
      assert Reservoir.list_history() == [history]
    end

    test "get_history!/1 returns the history with given id" do
      history = history_fixture()
      assert Reservoir.get_history!(history.id) == history
    end

    test "create_history/1 with valid data creates a history" do
      assert {:ok, %History{} = history} = Reservoir.create_history(@valid_attrs)
      assert history.name == "some name"
    end

    test "create_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reservoir.create_history(@invalid_attrs)
    end

    test "update_history/2 with valid data updates the history" do
      history = history_fixture()
      assert {:ok, %History{} = history} = Reservoir.update_history(history, @update_attrs)
      assert history.name == "some updated name"
    end

    test "update_history/2 with invalid data returns error changeset" do
      history = history_fixture()
      assert {:error, %Ecto.Changeset{}} = Reservoir.update_history(history, @invalid_attrs)
      assert history == Reservoir.get_history!(history.id)
    end

    test "delete_history/1 deletes the history" do
      history = history_fixture()
      assert {:ok, %History{}} = Reservoir.delete_history(history)
      assert_raise Ecto.NoResultsError, fn -> Reservoir.get_history!(history.id) end
    end

    test "change_history/1 returns a history changeset" do
      history = history_fixture()
      assert %Ecto.Changeset{} = Reservoir.change_history(history)
    end
  end
end
