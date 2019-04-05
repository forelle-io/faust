defmodule FaustWeb.UserControllerTest do
  @moduledoc false

  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, Factories}
  import Phoenix.Controller, only: [view_template: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias Ecto.Changeset
  alias Faust.Accounts
  alias Faust.Accounts.User

  describe "index" do
    test "lists all users when user is not authorized", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "lists all users when user is authorized", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :index))

      assert conn.status == code(:ok)
      assert length(conn.assigns.users) == 1
    end
  end

  describe "new user" do
    test "renders form when user is not authorized", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))

      assert conn.status == code(:ok)
      assert view_template(conn) == "new.html"
    end

    test "renders form when user is authorized", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :new))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end
  end

  describe "create user" do
    test "redirects to show when data is valid and user is not authorized", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs())

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "User created successfully."
      assert redirected_to(conn) == Routes.session_path(conn, :new)
      assert %User{} = Accounts.get_user_by(%{name: "Name", surname: "Surname"})
    end

    test "redirects to show when data is valid and user is authorized", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> post(Routes.user_path(conn, :create), user: user_attrs())

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "renders errors when data is invalid and user is not authorized", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: %{user_attrs() | name: nil})

      assert conn.status == code(:ok)
      assert %Changeset{valid?: false} = conn.assigns.changeset
    end

    test "renders errors when data is invalid and user is authorized", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> authorize_conn(user)
        |> post(Routes.user_path(conn, :create), user: %{user_attrs() | name: nil})

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user when he is not authorized", %{
      conn: conn,
      user: user
    } do
      conn = get(conn, Routes.user_path(conn, :edit, user))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "renders form for editing chosen user when he is authorized", %{conn: conn, user: user} do
      conn =
        conn
        |> authorize_conn(user)
        |> get(Routes.user_path(conn, :edit, user))

      assert conn.status == code(:ok)
      assert %Changeset{valid?: true} = conn.assigns.changeset
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid and user is not authorized", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{name: "Faust"})

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "redirects when data is valid and user is authorized", %{conn: conn, user: user} do
      conn =
        conn
        |> authorize_conn(user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: "Faust"})

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "User updated successfully."
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)
    end

    test "renders errors when data is invalid and user is not authorized", %{
      conn: conn,
      user: user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: %{name: nil})

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "renders errors when data is invalid and user is authorized", %{conn: conn, user: user} do
      conn =
        conn
        |> authorize_conn(user)
        |> put(Routes.user_path(conn, :update, user), user: %{name: nil})

      assert conn.status == code(:ok)
      assert %Changeset{valid?: false} = conn.assigns.changeset
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user when user is not authorized", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "deletes chosen user when user is authorized", %{conn: conn, user: user} do
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
  end

  # Private functions ----------------------------------------------------------

  defp create_user(_), do: {:ok, user: insert(:user)}
end
