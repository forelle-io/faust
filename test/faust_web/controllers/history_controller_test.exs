defmodule FaustWeb.HistoryControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, ReservoirFixtures}
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias Ecto.Changeset
  alias FaustWeb.{HistoryController, HistoryView}

  describe "new" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_history_path(conn, :new, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания истории, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_history_path(conn, :new, current_water))

      assert conn.status == code(:ok)
      assert controller_module(conn) == HistoryController
      assert view_module(conn) == HistoryView
      assert view_template(conn) == "new.html"
    end
  end

  describe "create" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_history_path(conn, :new, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания историии, когда пользователь авторизован и данные не валидны", %{
      conn: conn
    } do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> post(Routes.water_history_path(conn, :create, current_water), %{
          "history" => %{history_attrs(current_water) | "type" => nil}
        })

      assert conn.status == code(:ok)
      assert %Changeset{errors: errors, valid?: false} = conn.assigns.changeset
      assert errors[:type] == {"can't be blank", [validation: :required]}
      assert controller_module(conn) == HistoryController
      assert view_module(conn) == HistoryView
      assert view_template(conn) == "new.html"
    end

    test "страница истории, когда пользователь авторизован и данные валидны", %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> post(Routes.water_history_path(conn, :create, current_water), %{
          "history" => history_attrs(current_water)
        })

      assert conn.status == code(:found)

      %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.water_path(conn, :show, id)
    end
  end

  describe "delete" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = delete(conn, Routes.history_path(conn, :delete, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на главную страницу водоемов, когда пользователь авторизован и водоем удален",
         %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)
      current_history = history_fixture(current_water)

      conn =
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.history_path(conn, :delete, current_history))

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "История удалена"
      assert redirected_to(conn) == Routes.water_path(conn, :show, current_water)
    end

    test "запрет удаления чужой истории, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()
      other_water = other_user_fixture() |> water_fixture()
      other_history = history_fixture(other_water)

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.history_path(conn, :delete, other_history))
      end
    end
  end
end

