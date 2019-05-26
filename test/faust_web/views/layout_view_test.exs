defmodule FaustWeb.Views.LayoutViewTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.AccountFixtures

  alias FaustWeb.LayoutView
  alias Phoenix.HTML

  describe "clickable_logotype" do
    test "когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      clickable_logotype =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :index))
        |> LayoutView.clickable_logotype()
        |> HTML.safe_to_string()

      assert clickable_logotype ==
               "<a href=\"/users/#{current_user.id}\"><img height=\"72\" src=\"/images/logotype.png\"></a>"
    end

    test "когда пользователь не авторизован", %{conn: conn} do
      clickable_logotype =
        conn
        |> get(Routes.page_path(conn, :index))
        |> LayoutView.clickable_logotype()
        |> HTML.safe_to_string()

      assert clickable_logotype ==
               "<a href=\"/\"><img height=\"72\" src=\"/images/logotype.png\"></a>"
    end
  end
end
