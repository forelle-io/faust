defmodule FaustWeb.OrganizationControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.Factories
  import Plug.Conn.Status, only: [code: 1]

  describe "index" do
    test "redirects to session page when user is not authorized", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "lists all organization when user is authorized", %{conn: conn} do
      user = insert(:user)
      insert_list(1, :organization)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.organization_path(conn, :index))

      assert conn.status == code(:ok)
      assert length(conn.assigns.organization) == 1
    end
  end

  describe "show organization" do
    setup [:create_organization]

    test "redirects to session page when user is not authorized", %{
      conn: conn,
      organization: organization
    } do
      conn = get(conn, Routes.organization_path(conn, :show, organization))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "renders page when user is authorized", %{conn: conn, organization: organization} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.organization_path(conn, :show, organization))

      assert conn.status == code(:ok)
      assert conn.assigns.organization.id == organization.id
    end
  end

  # Private functions ----------------------------------------------------------

  defp create_organization(_), do: {:ok, organization: insert(:organization)}
end
