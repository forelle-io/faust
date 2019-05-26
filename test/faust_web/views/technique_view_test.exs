defmodule FaustWeb.Views.TechniquesViewTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.Factories

  alias FaustWeb.TechniquesView

  test "techniques_for_multiple_select" do
    insert_list(2, :fishing_fish)

    case TechniquesView.techniques_for_multiple_select() do
      techniques_list when is_list(techniques_list) ->
        Enum.all?(techniques_list, fn {k, v} -> is_bitstring(k) and is_integer(v) end)

      _ ->
        false
    end
  end

  describe "techniques_tags" do
    test "когда список пустой", %{conn: conn} do
      assert TechniquesView.techniques_tags(conn, []) == ""
    end

    test "когда список содержит 2 техники", %{conn: conn} do
      techniques_list = insert_list(2, :fishing_technique)
      regex = ~r/\A(<a class=\"topic\" href=\"\/users\">[а-я ]{1,}_[a-z]{4}<\/a>){1,}\z/u
      assert TechniquesView.techniques_tags(conn, techniques_list) =~ regex
    end
  end
end
