defmodule Faust.Accounts.AuthenticationHelperTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, Factories, SessionFixtures}
  import Plug.Conn.Status, only: [code: 1]

  alias Faust.Guardian
  alias FaustWeb.AuthenticationHelper

  describe "sign_in" do
    test "редирект на главную страницу, когда credential не существует", %{conn: conn} do
      conn = AuthenticationHelper.sign_in(conn, nil)

      assert redirected_to(conn) == assert(Routes.page_path(conn, :index))
    end

    test "редирект на главную страницу, когда credential существует и ассоциация неправильная",
         %{conn: conn} do
      user_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create), credential: %{session_user_attrs() | "association" => "association"})

      assert redirected_to(conn) == assert(Routes.page_path(conn, :index))
    end

    test "редирект на страницу пользователя, когда credential существует и параметры совпадают для user",
         %{conn: conn} do
      user = user_fixture()

      conn = post(conn, Routes.session_path(conn, :create), credential: session_user_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "редирект на страницу создания новой сессии, когда credential существует и параметры не совпадают для user",
         %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_user_attrs() | "unique" => "unique"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу организации, когда credential существует и данные валидны для organization",
         %{conn: conn} do
      organization = organization_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create), credential: session_organization_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.organization_path(conn, :show, organization)
    end

    test "редирект на страницу создания новой сессии, когда credential существует и данные не валидны для organization",
         %{conn: conn} do
      organization_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_organization_attrs() | "unique" => "unique"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    # TODO: Написать тест для ассоциации chief "редирект на страницу shief,
    # когда credential существует, и данные валидны для shief"

    test "редирект на страницу создания новой сессии, когда credential существует и данные не валидны для chief",
         %{conn: conn} do
      chief_fixture()

      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_chief_attrs() | "unique" => "unique"}
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

    test "редирект на главную страницу, когда разрушает сессию user", %{conn: conn} do
      # TODO: Сначала нужно авторизовать в сесии, а только разрушать ее
      conn = AuthenticationHelper.sign_out(conn, "user")
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "редирект на главную страницу, когда разрушает сессию organization", %{conn: conn} do
      # TODO: Сначала нужно авторизовать в сесии, а только разрушать ее
      conn = AuthenticationHelper.sign_out(conn, "organization")

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "редирект на главную страницу, когда разрушает сессию chief", %{conn: conn} do
      # TODO: Сначала нужно авторизовать в сесии, а только разрушать ее
      conn = AuthenticationHelper.sign_out(conn, "chief")

      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "current_organization" do
    test "когда organization в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.current_organization(conn)
    end

    test "когда organization в соединении присутствует", %{conn: conn} do
      organization = insert(:accounts_organization)
      conn = Guardian.Plug.sign_in(conn, organization, %{}, key: :organization)

      assert organization.id == AuthenticationHelper.current_organization(conn).id
    end
  end

  describe "current_сhief" do
    test "когда сhief в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.current_chief(conn)
    end

    test "когда сhief в соединении присутствует", %{conn: conn} do
      chief = insert(:accounts_chief)
      conn = Guardian.Plug.sign_in(conn, chief, %{}, key: :chief)

      assert chief.id == AuthenticationHelper.current_chief(conn).id
    end
  end

  describe "authenticated_organization?" do
    test "когда organization в соединении отсутствует", %{conn: conn} do
      refute AuthenticationHelper.authenticated_organization?(conn)
    end

    test "когда organization в соединении присутвует", %{conn: conn} do
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
