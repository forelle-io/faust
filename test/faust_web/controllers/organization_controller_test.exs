defmodule FaustWeb.OrganizationControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, Factories}
  import Plug.Conn.Status, only: [code: 1]

  alias Ecto.Changeset
  alias Faust.Accounts
  alias Faust.Accounts.Organization

  describe "index" do
    test "lists all organization when user is not authorized", %{conn: conn} do
      conn = get(conn, Routes.organization_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  test "lists all organization when user is authorized", %{conn: conn} do
    user = insert(:user)
    organization = insert_list(5, :organization)

    conn =
      conn
      |> authorize_conn(user)
      |> get(Routes.organization_path(conn, :index))

    assert conn.status == code(:ok)
    assert length(conn.assigns.organization) == 5
 end

 describe "show" do
  test "redirects to show organization when user is not authorized", %{conn: conn} do
    organization = insert(:organization)
    conn = get(conn, Routes.organization_path(conn, :show, organization))

    assert conn.status == code(:found)
  end

  test "redirects to show organization when user is authorized", %{conn: conn} do
    user = insert(:user)
    organization = insert(:organization)

    conn =
      conn
      |> authorize_conn(user)
      |> get(Routes.organization_path(conn, :show, organization), organization: organization_attrs())

    assert conn.status == code(:ok)
  end
 end
end
