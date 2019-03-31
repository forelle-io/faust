defmodule FaustWeb.ChiefController do
  use FaustWeb, :controller

  alias Faust.Accounts
  alias Faust.Accounts.Chief
  alias Faust.Repo

  def index(conn, _params) do
    chief = Accounts.list_chief()
    render(conn, "index.html", chief: chief)
  end

  def new(conn, _params) do
    changeset = Accounts.change_chief(%Chief{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"chief" => chief_params}) do
    case Accounts.create_chief(chief_params) do
      {:ok, chief} ->
        conn
        |> put_flash(:info, "Chief created successfully.")
        |> redirect(to: Routes.chief_path(conn, :show, chief))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    chief = Accounts.get_chief!(id)
    render(conn, "show.html", chief: chief)
  end

  def edit(conn, %{"id" => id}) do
    chief = get_chief_with_preloads(id, :credential)
    changeset = Accounts.change_chief(chief)
    render(conn, "edit.html", chief: chief, changeset: changeset)
  end

  def update(conn, %{"id" => id, "chief" => chief_params}) do
    chief = get_chief_with_preloads(id, :credential)

    case Accounts.update_chief(chief, chief_params) do
      {:ok, chief} ->
        conn
        |> put_flash(:info, "Chief updated successfully.")
        |> redirect(to: Routes.chief_path(conn, :show, chief))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", chief: chief, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chief = Accounts.get_chief!(id)
    {:ok, _chief} = Accounts.delete_chief(chief)

    conn
    |> put_flash(:info, "Chief deleted successfully.")
    |> redirect(to: Routes.chief_path(conn, :index))
  end

   # Private functions ----------------------------------------------------------

   defp get_chief_with_preloads(id, preloads) do
    id
    |> Accounts.get_chief!()
    |> Repo.preload(preloads)
  end
end
