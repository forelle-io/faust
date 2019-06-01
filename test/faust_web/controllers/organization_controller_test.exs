defmodule FaustWeb.OrhanizationControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.AccountFixtures
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias FaustWeb.{OrganizationController, OrganizationView}

  describe "index" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница списка всех организация, когда пользователь авторизован", %{conn: conn} do
      _current_organization = organization_fixture()
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.organization_path(conn, :index))

      assert conn.status == code(:ok)
      assert length(conn.assigns.organization) == 1
      assert controller_module(conn) == OrganizationController
      assert view_module(conn) == OrganizationView
      assert view_template(conn) == "index.html"
    end
  end

  describe "show" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :show, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница текущей организации, когда пользователь авторизован", %{conn: conn} do
      current_organization = organization_fixture()
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.organization_path(conn, :show, current_organization))

      assert conn.status == code(:ok)
      assert controller_module(conn) == OrganizationController
      assert view_module(conn) == OrganizationView
      assert view_template(conn) == "show.html"
    end
  end
end
