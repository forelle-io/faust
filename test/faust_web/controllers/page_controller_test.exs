defmodule FaustWeb.PageControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.AccountFixtures
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias FaustWeb.{PageController, PageView}


  describe "index" do
    test "главная страница, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :index))

      assert conn.status == code(:ok)
      assert controller_module(conn) == PageController
      assert view_module(conn) == PageView
      assert view_template(conn) == "index.html"
    end

    test "страница , когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.page_path(conn, :index))

      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
      assert conn.status == code(:found)
    end
  end
end
