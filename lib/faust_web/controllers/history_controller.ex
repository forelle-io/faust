defmodule FaustWeb.HistoryController do
  use FaustWeb, :controller

  alias Faust.Reservoir
  alias Faust.Reservoir.History

  action_fallback FaustWeb.FallbackController

  def new(conn, %{"water_id" => water_id}) do
    water = Reservoir.get_water!(water_id)

    with :ok <- Bodyguard.permit(History, :new, current_user(conn), water) do
      changeset = Reservoir.change_history(%History{})
      render(conn, "new.html", changeset: changeset, water: water)
    end
  end

  def create(conn, %{"water_id" => water_id, "history" => history_params}) do
    water = Reservoir.get_water!(water_id)

    created_history =
      history_params
      |> Map.put_new("water", water)
      |> Reservoir.create_history()

    case created_history do
      {:ok, _history} ->
        conn
        |> put_flash(:info, "История успешно создана")
        |> redirect(to: Routes.water_path(conn, :show, water))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, water: water)
    end
  end

  def delete(conn, %{"id" => id}) do
    {:ok, history} =
      id
      |> Reservoir.get_history!()
      |> Faust.Repo.preload(:water)
      |> Reservoir.delete_history()

    conn
    |> put_flash(:info, "История удалена")
    |> redirect(to: Routes.water_path(conn, :show, history.water))
  end
end
