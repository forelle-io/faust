defmodule Faust.Accounts.UserHelperTest do
  @moduledoc false
  use FaustWeb.ConnCase

  alias FaustWeb.Accounts.UserHelper

  describe "offset_rank_years" do
    test "получение интервала даты со значением смещения 100 лет по умолчанию" do
      offset = 100
      list_years = UserHelper.offset_rank_years() |> Enum.to_list()
      current_year = DateTime.utc_now().year

      assert Enum.count(list_years) == offset + 1
      assert current_year - offset == List.first(list_years)
      assert List.last(list_years) == current_year
    end

    test "получение интервала даты со значением смещения 50 лет" do
      offset = 50
      list_years = offset |> UserHelper.offset_rank_years() |> Enum.to_list()
      current_year = DateTime.utc_now().year

      assert Enum.count(list_years) == offset + 1
      assert current_year - offset == List.first(list_years)
      assert List.last(list_years) == current_year
    end
  end
end
