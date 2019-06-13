defmodule Faust.Accounts.AuthenticationHelperTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.Factories

  alias Faust.Guardian
  alias FaustWeb.AuthenticationHelper

  describe "sign_in" do
    test "авторизация, когда  не получен ключ", %{conn: conn} do
      conn = AuthenticationHelper.sign_in(conn, nil)

      assert redirected_to = Routes.page_path(conn, :index)
    end
  end

  describe "sign_out" do
    test "выход, когда  не получен ключ", %{conn: conn} do
      conn = AuthenticationHelper.sign_out(conn, nil)

      assert redirected_to = Routes.page_path(conn, :index)
    end
  end

  describe "current_organization" do
    test "когда организация в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.current_organization(conn)
    end

    test "когда организация в соединении присутствует", %{conn: conn} do
      organization = insert(:accounts_organization)
      conn = Guardian.Plug.sign_in(conn, organization, %{}, key: :organization)

      assert organization.id == AuthenticationHelper.current_organization(conn).id
    end
  end

  describe "current_shief" do
    test "когда администратор в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.current_chief(conn)
    end

    test "когда администратор в соединении присутствует", %{conn: conn} do
      chief = insert(:accounts_chief)
      conn = Guardian.Plug.sign_in(conn, chief, %{}, key: :chief)

      assert chief.id == AuthenticationHelper.current_chief(conn).id
    end
  end

  describe "authenticated_organization?" do
    test "когда организация в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.authenticated_organization?(conn)
    end

    test "когда организация в соединении присутвует", %{conn: conn} do
      organization = insert(:accounts_organization)
      conn = Guardian.Plug.sign_in(conn, organization, %{}, key: :organization)

      assert AuthenticationHelper.authenticated_organization?(conn)
    end
  end

  describe "authenticated_chief?" do
    test "когда chief в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.authenticated_chief?(conn)
    end

    test "когда chief в соединении присутвует", %{conn: conn} do
      chief = insert(:accounts_chief)
      conn = Guardian.Plug.sign_in(conn, chief, %{}, key: :chief)

      assert AuthenticationHelper.authenticated_chief?(conn)
    end
  end
end
