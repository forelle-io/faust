defmodule FaustWeb.HistoryController do
  use FaustWeb, :controller

  alias Faust.Reservoir
  alias Faust.Reservoir.History

  action_fallback FaustWeb.FallbackController

  def index(conn, %{"water_id" => water_id}) do
    histories = Reservoir.list_histories(water_id)

    render(conn, "index.html", histories: histories, water: Reservoir.get_water!(water_id))
  end

  def new(conn, %{"water_id" => water_id}) do
    changeset = Reservoir.change_history(%History{})
    render(conn, "new.html", changeset: changeset, water: Reservoir.get_water!(water_id))
  end

  def create(conn, %{"water_id" => water_id, "history" => history_params}) do
    created_history =
      history_params
      |> Map.put_new("water", Reservoir.get_water!(water_id))
      |> Reservoir.create_history()

    case created_history do
      {:ok, history} ->
        conn
        |> put_flash(:info, "История успешно создана")
        |> redirect(to: Routes.history_path(conn, :show, history))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    history = Reservoir.get_history!(id)
    render(conn, "show.html", history: history)
  end

  # history.water

  def edit(conn, %{"id" => id}) do
    history = Reservoir.get_history!(id)
    changeset = Reservoir.change_history(history)
    render(conn, "edit.html", history: history, changeset: changeset)
  end

  def update(conn, %{"id" => id, "history" => history_params}) do
    history = Reservoir.get_history!(id)

    case Reservoir.update_history(history, history_params) do
      {:ok, history} ->
        conn
        |> put_flash(:info, "История успешно обновлена")
        |> redirect(to: Routes.history_path(conn, :edit, history))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", history: history, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    history =
      id
      |> Reservoir.get_history!()
      |> Faust.Repo.preload(:water)

    conn
    |> put_flash(:info, "История удалена")
    |> redirect(to: Routes.water_history_path(conn, :index, history.water))
  end
end
