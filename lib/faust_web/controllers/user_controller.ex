defmodule FaustWeb.UserController do
  use FaustWeb, :controller

  import FaustWeb.FishHelper, only: [fetch_fishes_params: 2]
  import FaustWeb.TechniqueHelper, only: [fetch_techniques_params: 2]

  alias Faust.Accounts
  alias Faust.Accounts.User
  alias Faust.Repo

  action_fallback FaustWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users([:fishes, :techniques])
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
    with :ok <- Bodyguard.permit(User, :edit, current_user(conn), String.to_integer(id)) do
      user = user_preloader(conn, id)
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with :ok <- Bodyguard.permit(User, :update, current_user(conn), String.to_integer(id)) do
      user = user_preloader(conn, id)

      case Accounts.update_user(user, handle_user_params(user, user_params)) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.user_path(conn, :edit, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = current_user(conn)

    with :ok <- Bodyguard.permit(User, :delete, current_user, String.to_integer(id)) do
      {:ok, _user} = Accounts.delete_user(current_user)

      conn
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: Routes.user_path(conn, :index))
    end
  end

  # Приватные функции ----------------------------------------------------------

  defp user_preloader(conn, id) do
    current_user = current_user(conn)

    if current_user && current_user.id == String.to_integer(id) do
      Repo.preload(current_user, [:fishes, :techniques])
    else
      id
      |> Accounts.get_user!()
      |> Repo.preload([:credential, :fishes, :techniques])
    end
  end

  defp handle_user_params(user, user_params) do
    user_params
    |> fetch_fishes_params(user.fishes)
    |> fetch_techniques_params(user.techniques)
  end
end
