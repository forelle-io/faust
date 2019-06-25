defmodule FaustWeb.UserControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.AccountFixtures
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias Ecto.Changeset
  alias Faust.Accounts.User
  alias FaustWeb.{UserController, UserView}

  describe "index" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница списка всех пользователей, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :index))

      # TODO: Написать тестирование для LiveView
      assert conn.status == code(:ok)
    end
  end

  describe "new" do
    test "страница создания пользователя, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))

      assert conn.status == code(:ok)
      assert controller_module(conn) == UserController
      assert view_module(conn) == UserView
      assert view_template(conn) == "new.html"
    end

    test "редирект на страницу пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :new))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
    end
  end

  describe "create" do
    test "редирект на страницу входа, когда пользователь не авторизован и данные валидны", %{
      conn: conn
    } do
      user_attrs = user_attrs()
      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания нового пользователя, когда пользователь не авторизован и данные не валидны",
         %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{user_attrs() | "name" => nil})

      assert conn.status == code(:ok)
      assert %Changeset{errors: errors, valid?: false} = conn.assigns.changeset
      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert controller_module(conn) == UserController
      assert view_module(conn) == UserView
      assert view_template(conn) == "new.html"
    end

    test "редирект на страницу пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> post(Routes.user_path(conn, :create), user: user_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, current_user)
    end
  end

  describe "show" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница текущего пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :show, current_user))

      assert conn.status == code(:ok)
      assert controller_module(conn) == UserController
      assert view_module(conn) == UserView
      assert view_template(conn) == "show.html"
    end

    test "страница другого пользователя, когда текущий пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()
      other_user = other_user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :show, other_user))

      assert conn.status == code(:ok)
      assert controller_module(conn) == UserController
      assert view_module(conn) == UserView
      assert view_template(conn) == "show.html"
      assert %User{} = conn.assigns.user
      assert Enum.empty?(conn.assigns.list_followee_ids)
    end
  end

  describe "edit" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :edit, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница редактирования текущего пользователя, когда пользователь авторизован", %{
      conn: conn
    } do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :edit, current_user))

      assert conn.status == code(:ok)
      assert controller_module(conn) == UserController
      assert view_module(conn) == UserView
      assert view_template(conn) == "edit.html"
      assert %User{} = conn.assigns.user
    end

    test "запрет редактирования страницы другого пользователя, когда пользователь авторизован", %{
      conn: conn
    } do
      current_user = user_fixture()
      other_user = other_user_fixture()

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> get(Routes.user_path(conn, :edit, other_user))
      end
    end
  end

  describe "update" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :update, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу редактирования пользователя, когда пользователь авторизован и данные валидны",
         %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> put(Routes.user_path(conn, :update, current_user), %{
          "user" => %{"name" => "Карл", "surname" => "Фридрих"}
        })

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "Аккаунт обновлен"
      assert redirected_to(conn) == Routes.user_path(conn, :edit, current_user)
    end

    test "страница редактирования пользователя, когда пользователь авторизован и данные не валидны",
         %{
           conn: conn
         } do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> put(Routes.user_path(conn, :update, current_user), %{
          "user" => %{"name" => nil, "surname" => nil}
        })

      assert conn.status == code(:ok)
      assert %Changeset{errors: errors, valid?: false} = conn.assigns.changeset
      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:surname] == {"can't be blank", [validation: :required]}
      assert controller_module(conn) == UserController
      assert view_module(conn) == UserView
      assert view_template(conn) == "edit.html"
    end

    test "запрет редактирования другого пользователя, когда пользователь авторизован", %{
      conn: conn
    } do
      current_user = user_fixture()
      other_user = other_user_fixture()

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> put(Routes.user_path(conn, :update, other_user), %{
          "user" => %{"name" => "Карл", "surname" => "Фридрих"}
        })
      end
    end
  end

  describe "delete" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = delete(conn, Routes.user_path(conn, :delete, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу пользователей, когда пользователь авторизован и удален", %{
      conn: conn
    } do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.user_path(conn, :delete, current_user))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "запрет удаления другого пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.user_path(conn, :delete, other_user_fixture()))
      end
    end
  end
end
