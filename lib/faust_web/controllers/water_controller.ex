defmodule FaustWeb.WaterController do
  use FaustWeb, :controller

  alias Faust.Reservoir
  alias Faust.Reservoir.Water

  def index(conn, _params) do
    waters = Reservoir.list_waters()
    render(conn, "index.html", waters: waters)
  end

  def new(conn, _params) do
    changeset = Reservoir.change_water(%Water{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"water" => water_params}) do
    case Reservoir.create_water(water_params) do
      {:ok, water} ->
        conn
        |> put_flash(:info, "Water created successfully.")
        |> redirect(to: Routes.water_path(conn, :show, water))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    water = Reservoir.get_water!(id)
    render(conn, "show.html", water: water)
  end

  def edit(conn, %{"id" => id}) do
    water = Reservoir.get_water!(id)
    changeset = Reservoir.change_water(water)
    render(conn, "edit.html", water: water, changeset: changeset)
  end

  def update(conn, %{"id" => id, "water" => water_params}) do
    water = Reservoir.get_water!(id)

    case Reservoir.update_water(water, water_params) do
      {:ok, water} ->
        conn
        |> put_flash(:info, "Water updated successfully.")
        |> redirect(to: Routes.water_path(conn, :edit, water))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", water: water, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    water = Reservoir.get_water!(id)
    {:ok, _water} = Reservoir.delete_water(water)

    conn
    |> put_flash(:info, "Water deleted successfully.")
    |> redirect(to: Routes.water_path(conn, :index))
  end
end
