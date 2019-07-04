defmodule Faust.Accounts.UserHelperTest do
  @moduledoc false
  use FaustWeb.ConnCase

  alias FaustWeb.Accounts.UserHelper

  describe "offset_rank_years" do
    test "получаем интервал Даты в 100 лет, не передавая параметры" do
      assert UserHelper.offset_rank_years() ==
               (DateTime.utc_now().year - 100)..DateTime.utc_now().year
    end

    test "получаем интервал Даты в 50 лет" do
      assert UserHelper.offset_rank_years(50) ==
               (DateTime.utc_now().year - 50)..DateTime.utc_now().year
    end
  end
end
