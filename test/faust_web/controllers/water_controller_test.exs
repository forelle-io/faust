defmodule FaustWeb.WaterControllerTest do
  @moduledoc false
  use FaustWeb.ConnCase

  import Faust.Support.{AccountFixtures, ReservoirFixtures}
  import Phoenix.Controller, only: [controller_module: 1, view_template: 1, view_module: 1]
  import Plug.Conn.Status, only: [code: 1]

  alias Ecto.Changeset
  alias Faust.Reservoir.Water
  alias FaustWeb.{WaterController, WaterView}

  describe "index" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница списка всех водоемов пользователя, когда пользователь авторизован", %{
      conn: conn
    } do
      current_user = user_fixture()
      water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :index, %{"user_id" => current_user.id}))

      assert conn.status == code(:ok)
      assert length(conn.assigns.list_waters_page.entries) == 1
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "index.html"
    end

    test "запрет страницы списка всех водоемов пользователя, когда пользователь авторизован", %{
      conn: conn
    } do
      current_user = user_fixture()
      water_fixture(current_user)

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :index, %{"user_id" => current_user.id + 1}))
      end
    end

    test "страница списка всех водоемов, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()
      water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :index))

      assert conn.status == code(:ok)
      assert length(conn.assigns.list_waters_page.entries) == 1
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "index.html"
    end
  end

  describe "new" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_path(conn, :new))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания водоема, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :new))

      assert conn.status == code(:ok)
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "new.html"
    end
  end

  describe "create" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_path(conn, :new))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница создания водоема, когда пользователь авторизован и данные не валидны", %{
      conn: conn
    } do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> post(Routes.water_path(conn, :create), %{
          "water" => %{water_attrs(current_user) | "name" => nil}
        })

      assert conn.status == code(:ok)
      assert %Changeset{errors: errors, valid?: false} = conn.assigns.changeset
      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "new.html"
    end

    test "страница водоема, когда пользователь авторизован и данные валидны", %{conn: conn} do
      current_user = user_fixture()

      conn =
        conn
        |> authorize_conn(current_user)
        |> post(Routes.water_path(conn, :create), %{"water" => water_attrs(current_user)})

      assert conn.status == code(:found)

      %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.water_path(conn, :show, id)
    end
  end

  describe "show" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_path(conn, :show, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница водоема текущего пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :show, current_water))

      assert conn.status == code(:ok)
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "show.html"
      assert %Water{} = conn.assigns.water
    end

    test "страница водоема, когда пользователь авторизован", %{conn: conn} do
      other_water = other_user_fixture() |> water_fixture()

      conn =
        conn
        |> authorize_conn(user_fixture())
        |> get(Routes.water_path(conn, :show, other_water))

      assert conn.status == code(:ok)
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "show.html"
      assert %Water{} = conn.assigns.water
    end
  end

  describe "edit" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.water_path(conn, :edit, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "страница редактирования водоема текущего пользователя, когда пользователь авторизован",
         %{
           conn: conn
         } do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :edit, current_water))

      assert conn.status == code(:ok)
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "edit.html"
      assert %Water{} = conn.assigns.water
    end

    test "запрет редактирования страницы водоема другого пользователя, когда пользователь авторизован",
         %{
           conn: conn
         } do
      current_user = user_fixture()
      other_water = other_user_fixture() |> water_fixture()

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> get(Routes.water_path(conn, :edit, other_water))
      end
    end
  end

  describe "update" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :update, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на страницу редактирования водоема текущего пользователя, когда пользователь авторизован и данные валидны",
         %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> put(Routes.water_path(conn, :update, current_water), %{
          "water" => %{"name" => "Хитрый окунь"}
        })

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "Водоем успешно обновлен"
      assert redirected_to(conn) == Routes.water_path(conn, :edit, current_water)
    end

    test "страница редактирования водоема, когда пользователь авторизован и данные не валидны", %{
      conn: conn
    } do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> put(Routes.water_path(conn, :update, current_water), %{"water" => %{"name" => nil}})

      assert conn.status == code(:ok)
      assert %Changeset{errors: errors, valid?: false} = conn.assigns.changeset
      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert controller_module(conn) == WaterController
      assert view_module(conn) == WaterView
      assert view_template(conn) == "edit.html"
    end

    test "запрет редактирования страницы водоема другого пользователя, когда пользователь авторизован",
         %{conn: conn} do
      current_user = user_fixture()
      other_water = other_user_fixture() |> water_fixture()

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> put(Routes.water_path(conn, :update, other_water), %{
          "water" => %{"name" => "Хитрый окунь"}
        })
      end
    end
  end

  describe "delete" do
    test "редирект на страницу входа, когда пользователь не авторизован", %{conn: conn} do
      conn = delete(conn, Routes.water_path(conn, :delete, 1))

      assert conn.status == code(:found)
      assert redirected_to(conn) == Routes.session_path(conn, :new)
    end

    test "редирект на главную страницу водоемов, когда пользователь авторизован и водоем удален",
         %{conn: conn} do
      current_user = user_fixture()
      current_water = water_fixture(current_user)

      conn =
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.water_path(conn, :delete, current_water))

      assert conn.status == code(:found)
      assert conn.private[:phoenix_flash]["info"] == "Водоем удален"
      assert redirected_to(conn) == Routes.water_path(conn, :index)
    end

    test "запрет удаления другого пользователя, когда пользователь авторизован", %{conn: conn} do
      current_user = user_fixture()
      other_water = other_user_fixture() |> water_fixture()

      assert_error_sent 403, fn ->
        conn
        |> authorize_conn(current_user)
        |> delete(Routes.user_path(conn, :delete, other_water))
      end
    end
  end
end
