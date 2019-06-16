defmodule Faust.Accounts.AuthenticationHelperTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.AccountFixtures
  import Faust.Support.Factories
  import Plug.Conn.Status, only: [code: 1]

  alias Faust.Guardian
  alias FaustWeb.AuthenticationHelper

  describe "sign_in" do
    test "редирект на главную страницу, когда credential не существует", %{conn: conn} do
      conn = AuthenticationHelper.sign_in(conn, nil)

      assert redirected_to(conn) == assert(Routes.page_path(conn, :index))
    end

    test "редирект на главную страницу, когда credential существует, а ассоциация неправильная",
         %{conn: conn} do
      user_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create), credential: session_attrs_bad_association())

      assert redirected_to(conn) == assert(Routes.page_path(conn, :index))
    end

    test "редирект на страницу пользователя, когда credential существует, и параметры совпадают для user",
         %{conn: conn} do
      current_user = user_fixture()
      conn = post(conn, Routes.session_path(conn, :create), credential: session_attrs_user())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
    end

    test "редирект на страницу создания новой сессии, когда credential существует, и параметры не совпадают для user",
         %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_attrs_user() | "unique" => "bad_solov9ev"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу организации, когда credential существует, и данные валидны для organization",
         %{conn: conn} do
      current_organization = organization_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create), credential: session_attrs_organization())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.organization_path(conn, :show, current_organization)
    end

    test "редирект на страницу создания новой сессии, когда credential существует, и данные не валидны для organization",
         %{conn: conn} do
      organization_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_attrs_organization() | "unique" => "bad_organization"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    # TODO: Написать тест для ассоциации chief "редирект на страницу shief,
    # когда credential существует, и данные валидны для shief"

    test "редирект на страницу создания новой сессии, когда credential существует, и данные не валидны для shief",
         %{conn: conn} do
      chief_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_attrs_shief() | "unique" => "bad_shief"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end
  end

  describe "sign_out" do
    test "редирект на главную страницу, когда параметры не совпадают", %{conn: conn} do
      conn = AuthenticationHelper.sign_out(conn, nil)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "редирект на главную страницу, когда action user", %{conn: conn} do
      conn = AuthenticationHelper.sign_out(conn, "user")

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "редирект на главную страницу, когда action organization", %{conn: conn} do
      conn = AuthenticationHelper.sign_out(conn, "organization")

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "редирект на главную страницу, когда action chief", %{conn: conn} do
      conn = AuthenticationHelper.sign_out(conn, "chief")

      assert redirected_to(conn) == Routes.page_path(conn, :index)
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

  # Приватные функции ----------------------------------------------------------

  defp session_attrs_user do
    %{
      "association" => "user",
      "password" => "password",
      "unique" => "solov9ev"
    }
  end

  defp session_attrs_organization do
    %{
      "association" => "organization",
      "password" => "password",
      "unique" => "goldencarp"
    }
  end

  defp session_attrs_shief do
    %{
      "association" => "shief",
      "password" => "password",
      "unique" => "admin"
    }
  end

  defp session_attrs_bad_association do
    %{
      "association" => "bad_association",
      "password" => "password",
      "unique" => "solov9ev"
    }
  end
end
