defmodule FaustWeb.UserControllerTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, Factories}
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias Ecto.Changeset
  alias FaustWeb.UserController

  describe "index" do
    test "редирект на страницу создания сессии, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "список всех пользователей, когда пользователь авторизован", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :index))

      assert conn.status == code(:ok)
      assert length(conn.assigns.users) == 1
      assert controller_module(conn) == UserController
      assert view_template(conn) == "index.html"
    end
  end

  describe "new" do
    test "рендеринг страницы создания нового пользователя, когда пользователь не авторизован", %{
      conn: conn
    } do
      conn = get(conn, Routes.user_path(conn, :new))

      assert conn.status == code(:ok)
      assert controller_module(conn) == UserController
      assert view_template(conn) == "new.html"
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

  describe "create" do
    test "редирект на страницу создания сессии, когда данные валидны пользователь не авторизован",
         %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs())

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "User created successfully."
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу пользователя, когда данные валидны и пользователь авторизован", %{
      conn: conn
    } do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> post(Routes.user_path(conn, :create), user: user_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "рендеринг ошибок, когда данные не валидны и пользователь не авторизован", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{user_attrs() | name: nil})

      assert conn.status == code(:ok)
      assert %Changeset{valid?: false} = conn.assigns.changeset
      assert controller_module(conn) == UserController
      assert view_template(conn) == "new.html"
    end

    test "редирект на страницу пользователя, когда данные не валидны и пользователь авторизован",
         %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> post(Routes.user_path(conn, :create), user: %{user_attrs() | name: nil})

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end
  end

  describe "show" do
    setup [:create_user]

    test "редирект на страницу создания сессии, когда пользователь не авторизован", %{
      conn: conn,
      user: user
    } do
      conn = get(conn, Routes.user_path(conn, :show, user))

      assert conn.status == code(:found)
    end

    test "рендер страницы пользователя, когда пользователь авторизован", %{conn: conn, user: user} do
      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :show, user))

      assert conn.status == code(:ok)
      assert conn.assigns.user.id == user.id
      assert controller_module(conn) == UserController
      assert view_template(conn) == "show.html"
    end
  end

  describe "edit" do
    setup [:create_user]

    test "редирект на страницу создания сессии, когда пользователь не авторизован", %{
      conn: conn,
      user: user
    } do
      conn = get(conn, Routes.user_path(conn, :edit, user))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "рендеринг страницы редактирования пользователя, когда пользователь авторизован", %{
      conn: conn,
      user: user
    } do
      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :edit, user))

      assert conn.status == code(:ok)
      assert %Changeset{valid?: true} = conn.assigns.changeset
      assert controller_module(conn) == UserController
      assert view_template(conn) == "edit.html"
    end

    test "исключительная ситуация с кодом 403 при попытке редактировать запрещенный ресурс", %{
      conn: conn,
      user: user
    } do
      assert_error_sent(403, fn ->
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :edit, insert(:user)))
      end)
    end
  end

  describe "update" do
    setup [:create_user]

    test "редирект на страницу создания сессии, когда пользователь не авторизован", %{
      conn: conn,
      user: user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{name: "Faust"})

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу пользователя, когда данные валидны и пользователь авторизован", %{
      conn: conn,
      user: user
    } do
      conn =
        conn
        |> authorize_conn(user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: "Faust"})

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "User updated successfully."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "редирект на страницу создания сессии, когда данные не валидны и пользователь не авторизован",
         %{
           conn: conn,
           user: user
         } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{name: nil})

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "рендеринг ошибок, когда данные не валидны и пользователь авторизован", %{
      conn: conn,
      user: user
    } do
      conn =
        conn
        |> authorize_conn(user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: nil})

      assert conn.status == code(:ok)
      assert %Changeset{valid?: false} = conn.assigns.changeset
      assert controller_module(conn) == UserController
      assert view_template(conn) == "edit.html"
    end

    test "исключительная ситуация с кодом 403 при попытке редактировать запрещенный ресурс", %{
      conn: conn,
      user: user
    } do
      assert_error_sent(403, fn ->
        conn
        |> authorize_conn(user)
        |> put(Routes.user_path(conn, :update, insert(:user)), user: %{name: "Faust"})
      end)
    end
  end

  describe "delete" do
    setup [:create_user]

    test "редирект на страницу создания сессии, когда данные не валидны и пользователь не авторизован",
         %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу списка всех пользователей, когда пользователь авторизован", %{
      conn: conn,
      user: user
    } do
      conn =
        conn
        |> authorize_conn(user)
        |> delete(Routes.user_path(conn, :delete, user))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end

    test "исключительная ситуация с кодом 403 при попытке редактировать запрещенный ресурс", %{
      conn: conn,
      user: user
    } do
      assert_error_sent(403, fn ->
        conn
        |> authorize_conn(user)
        |> delete(Routes.user_path(conn, :delete, insert(:user)))
      end)
    end
  end

  # Приватные функции ----------------------------------------------------------

  defp create_user(_), do: {:ok, user: insert(:user)}
end
