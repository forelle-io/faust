defmodule FaustWeb.SessionControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.AccountFixtures
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias FaustWeb.{SessionController, SessionView}

  describe "index" do
    test "редирект на страницу пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.session_path(conn, :new))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
    end

    test "страница новой сессии, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))

      assert conn.status == code(:ok)
      assert controller_module(conn) == SessionController
      assert view_module(conn) == SessionView
      assert view_template(conn) == "new.html"
      assert conn.assigns.association == :user
    end
  end

  describe "create" do
    setup do
      {:ok, current_user: user_fixture()}
    end

    test "редирект на страницу пользователя, когда пользователь авторизован", %{
      conn: conn,
      current_user: current_user
    } do
      conn =
        conn
        |> authorize_conn(current_user)
        |> post(Routes.session_path(conn, :create), credential: session_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
    end

    test "страница создания новой сессии, когда пользователь не авторизован и unique не валиден",
         %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_attrs() | "unique" => "bad_solov9ev"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания новой сессии, когда пользователь не авторизован и password не валиден",
         %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_attrs() | "password" => "bad_password"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания новой сессии, когда пользователь не авторизован и association не валиден",
         %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create),
          credential: %{session_attrs() | "association" => "bad_user"}
        )

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "страница создания новой сессии, когда пользователь не авторизован и данные валидны",
         %{conn: conn, current_user: current_user} do
      conn = post(conn, Routes.session_path(conn, :create), credential: session_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
      assert conn.private.guardian_user_token
    end
  end

  describe "delete" do
    setup do
      {:ok, current_user: user_fixture()}
    end

    test "редирект на страницу входа, когда пользователь не авторизован", %{
      conn: conn,
      current_user: current_user
    } do
      conn =
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.session_path(conn, :delete, action: "user"))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "редирект на главную страницу, когда пользователь авторизован", %{
      conn: conn,
      current_user: current_user
    } do
      conn =
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.session_path(conn, :delete, action: "user"))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
      refute conn.private.guardian_user_token
    end
  end

  # Приватные функции ----------------------------------------------------------

  defp session_attrs do
    %{
      "association" => "user",
      "password" => "password",
      "unique" => "solov9ev"
    }
  end
end
