defmodule FaustWeb.UserController do
  use FaustWeb, :controller

  alias Faust.Accounts
  alias Faust.Accounts.User
  alias Faust.Repo

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = user_preloader(conn, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = user_preloader(conn, id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = user_preloader(conn, id)

    case Accounts.update_user(user, handle_user_params(user, user_params)) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  # Приватные функции ----------------------------------------------------------

  defp user_preloader(conn, id) do
    current_user = current_user(conn)

    if current_user && current_user.id == String.to_integer(id) do
      Repo.preload(current_user, :fishes)
    else
      id
      |> Accounts.get_user!()
      |> Repo.preload([:credential, :fishes])
    end
  end

  defp handle_user_params(user, user_params) do
    handle_fish_params(user_params, user.fishes)
  end

  def handle_fish_params(user_params, user_fishes)
      when is_map(user_params) and is_list(user_fishes) do
    case user_params do
      %{"fishes_ids" => []} ->
        user_params

      %{"fishes_ids" => fishes} ->
        user_fishes = Enum.map(user_fishes, & &1.id)
        fishes = Enum.map(fishes, &String.to_integer/1)

        if Enum.sort(user_fishes) == Enum.sort(fishes) do
          %{user_params | "fishes_ids" => nil}
        else
          user_params
        end

      _ ->
        user_params
    end
  end
end
