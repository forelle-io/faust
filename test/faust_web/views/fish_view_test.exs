defmodule FaustWeb.FishViewTest do
  @moduledoc false

  use FaustWeb.ConnCase, async: true

  import Faust.Support.FishesFixtures, only: [fish_fixture: 0]

  alias FaustWeb.FishView

  describe "techniques_for_multiple_select" do
    test "когда рыба не создана" do
      assert FishView.fishes_for_multiple_select() == []
    end

    test "когда рыба создана" do
      fish_fixture()

      case FishView.fishes_for_multiple_select() do
        [{"форель", _id}] ->
          assert true

        _ ->
          assert false
      end
    end
  end

  describe "fishes_tags" do
    test "с пустым списком рыб", %{conn: conn} do
      assert FishView.fishes_tags(conn, []) == ""
    end

    test "с одной рыбой в списке", %{conn: conn} do
      assert FishView.fishes_tags(conn, [fish_fixture()]) ==
               "<a class=\"topic\" href=\"/users\">форель</a>"
    end
  end
end
