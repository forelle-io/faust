defmodule FaustWeb.PageControllerTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.Factories
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias FaustWeb.PageController

  describe "index" do
    test "получение главной страницы, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, "/")

      assert conn.status == code(:ok)
      assert controller_module(conn) == PageController
      assert view_template(conn) == "index.html"
    end

    test "редирект на страницу пользователя, когда пользователь авторизован", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :new))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end
  end
end
