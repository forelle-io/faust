defmodule FaustWeb.HistoryControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, ReservoirFixtures}
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  describe "new" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_history_path(conn, :new, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "create" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> post(Routes.water_history_path(conn, :create, current_water), %{
          "history" => %{history_attrs(current_water) | "type" => nil}
        })

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "delete" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = delete(conn, Routes.history_path(conn, :delete, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end
end
