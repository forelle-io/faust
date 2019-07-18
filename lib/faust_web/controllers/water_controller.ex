defmodule FaustWeb.WaterController do
  use FaustWeb, :controller

  import FaustWeb.FishHelper, only: [fetch_fishes_params: 2]
  import FaustWeb.TechniqueHelper, only: [fetch_techniques_params: 2]

  alias Faust.Repo
  alias Faust.Reservoir
  alias Faust.Reservoir.Water

  action_fallback FaustWeb.FallbackController

  def index(conn, %{"user_id" => user_id} = params) do
    user_id = String.to_integer(user_id)

    with :ok <-
           Bodyguard.permit(Water, :index, current_user(conn), %{
             params
             | "user_id" => user_id
           }) do
      waters = Reservoir.list_waters(user_id, [[user: :credential], :fishes, :techniques])

      render(conn, "index.html", waters: waters)
    end
  end

  def index(conn, _params) do
    waters = Reservoir.list_waters([[user: :credential], :fishes, :techniques])

    render(conn, "index.html", waters: waters)
  end

  def new(%Plug.Conn{assigns: %{changeset_water: changeset_water}} = conn, _params) do
    render(conn, "new.html", changeset: changeset_water)
  end

  def create(conn, %{"water" => water_params}) do
    created_water =
      water_params
      |> Map.put_new("user", current_user(conn))
      |> Reservoir.create_water()

    case created_water do
      {:ok, water} ->
        conn
        |> put_flash(:info, "Водоем успешно создан")
        |> redirect(to: Routes.water_path(conn, :show, water))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    water = water_preloader(conn, id)

    render(conn, "show.html", water: water)
  end

  def edit(conn, %{"id" => id}) do
    water = water_preloader(conn, id)

    with :ok <- Bodyguard.permit(Water, :edit, current_user(conn), water) do
      changeset = Reservoir.change_water(water)

      render(conn, "edit.html", water: water, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "water" => water_params}) do
    water = water_preloader(conn, id)

    with :ok <- Bodyguard.permit(Water, :update, current_user(conn), water) do
      case Reservoir.update_water(water, handle_water_params(water, water_params)) do
        {:ok, water} ->
          conn
          |> put_flash(:info, "Водоем успешно обновлен")
          |> redirect(to: Routes.water_path(conn, :edit, water))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", water: water, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    water = Reservoir.get_water!(id)

    with :ok <- Bodyguard.permit(Water, :delete, current_user(conn), water) do
      {:ok, _water} = Reservoir.delete_water(water)

      conn
      |> put_flash(:info, "Водоем удален")
      |> redirect(to: Routes.water_path(conn, :index))
    end
  end

  # Приватные функции ----------------------------------------------------------

  defp water_preloader(conn, id) do
    water = Reservoir.get_water!(id)

    case action_name(conn) do
      :show ->
        Repo.preload(water, [[user: :credential], :fishes, :techniques, :histories])

      _ ->
        Repo.preload(water, [:fishes, :techniques])
    end
  end

  defp handle_water_params(water, water_params) do
    water_params
    |> fetch_fishes_params(water.fishes)
    |> fetch_techniques_params(water.techniques)
  end
end
