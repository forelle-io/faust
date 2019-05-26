defmodule FaustWeb.Views.HistoryViewTest do
  @moduledoc false

  use Faust.DataCase

  alias FaustWeb.HistoryView

  test "types_select" do
    assert HistoryView.types_select() == ["создание", "реконструкция", "зарыбление", "закрытие"]
  end
end
