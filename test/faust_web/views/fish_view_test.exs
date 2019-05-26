defmodule FaustWeb.Views.FishViewTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.Factories

  alias FaustWeb.FishView

  test "fishes_for_multiple_select" do
    insert_list(2, :fishing_fish)

    case FishView.fishes_for_multiple_select() do
      fishes_list when is_list(fishes_list) ->
        Enum.all?(fishes_list, fn {k, v} -> is_bitstring(k) and is_integer(v) end)

      _ ->
        false
    end
  end

  describe "fishes_tags" do
    test "когда список пустой", %{conn: conn} do
      assert FishView.fishes_tags(conn, []) == ""
    end

    test "когда список содержит 2 рыбы", %{conn: conn} do
      fishes_list = insert_list(2, :fishing_fish)
      regex = ~r/\A(<a class=\"topic\" href=\"\/users\">[а-я]{1,}_[a-z]{4}<\/a>){1,}\z/u
      assert FishView.fishes_tags(conn, fishes_list) =~ regex
    end
  end
end
