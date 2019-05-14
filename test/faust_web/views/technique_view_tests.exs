defmodule FaustWeb.TechniqueTest do
  @moduledoc false

  use FaustWeb.ConnCase, async: true

  import Faust.Support.FishesFixtures, only: [technique_fixture: 0]

  alias FaustWeb.TechniquesView

  describe "techniques_for_multiple_select" do
    test "когда техника ловли не создана" do
      assert TechniquesView.techniques_for_multiple_select() == []
    end

    test "когда техника ловли создана" do
      technique_fixture()

      case TechniquesView.techniques_for_multiple_select() do
        [{"спиннинг", _id}] ->
          assert true

        _ ->
          assert false
      end
    end
  end

  describe "techniques_tags" do
    test "с пустым списком техник ловли", %{conn: conn} do
      assert TechniquesView.techniques_tags(conn, []) == ""
    end

    test "c одной техникой ловли", %{conn: conn} do
      assert TechniquesView.techniques_tags(conn, [technique_fixture()]) ==
               "<a class=\"topic\" href=\"/users\">спиннинг</a>"
    end
  end
end
