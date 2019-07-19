defmodule FaustWeb.HistoryController do
  use FaustWeb, :controller

  alias Faust.Reservoir
  alias Faust.Reservoir.History

  action_fallback FaustWeb.FallbackController

  def new(conn, %{"water_id" => water_id}) do
    water = Reservoir.get_water!(water_id)

    # TODO: использовать current_organization
    with :ok <- Bodyguard.permit(History, :new, current_user(conn), water) do
      changeset = Reservoir.change_history(%History{})
      render(conn, "new.html", changeset: changeset, water: water)
    end
  end

  def create(conn, %{"water_id" => water_id, "history" => history_params}) do
    water = Reservoir.get_water!(water_id)

    # TODO: использовать current_organization
    with :ok <- Bodyguard.permit(History, :create, current_user(conn), water) do
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
  end

  def delete(conn, %{"id" => id}) do
    history =
      id
      |> Reservoir.get_history!()
      |> Faust.Repo.preload(:water)

    # TODO: использовать current_organization
    with :ok <- Bodyguard.permit(History, :delete, current_user(conn), history.water) do
      {:ok, history} = Reservoir.delete_history(history)

      conn
      |> put_flash(:info, "История удалена")
      |> redirect(to: Routes.water_path(conn, :show, history.water))
    end
  end
end
