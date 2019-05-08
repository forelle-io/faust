defmodule FaustWeb.OrganizationControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, Factories}
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias FaustWeb.OrganizationController

  describe "index" do
    test "редирект на страницу создания сессии, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "список всех организаций, когда когда пользователь авторизован", %{conn: conn} do
      user = user_fixture()
      insert_list(1, :organization)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.organization_path(conn, :index))

      assert conn.status == code(:ok)
      assert length(conn.assigns.organization) == 1
      assert controller_module(conn) == OrganizationController
      assert view_template(conn) == "index.html"
    end
  end

  describe "show" do
    setup [:create_organization]

    test "редирект на страницу создания сессии, когда пользователь не авторизован", %{
      conn: conn,
      organization: organization
    } do
      conn = get(conn, Routes.organization_path(conn, :show, organization))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "рендеринг страницы организации, когда пользорватель авторизован", %{
      conn: conn,
      organization: organization
    } do
      user = user_fixture()

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.organization_path(conn, :show, organization))

      assert conn.status == code(:ok)
      assert conn.assigns.organization.id == organization.id
      assert controller_module(conn) == OrganizationController
      assert view_template(conn) == "show.html"
    end
  end

  # Private functions ----------------------------------------------------------

  defp create_organization(_), do: {:ok, organization: insert(:organization)}
end
