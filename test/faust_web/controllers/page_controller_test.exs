defmodule FaustWeb.PageControllerTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.Factories
  import Phoenix.Controller, only: [view_template: 1]
  import Plug.Conn.Status, only: [code: 1]

  describe "index" do
    test "get root page when user is not authorized", %{conn: conn} do
      conn = get(conn, "/")

      assert conn.status == code(:ok)
      assert view_template(conn) == "index.html"
    end

    test "show user page when he is authorized", %{conn: conn} do
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
