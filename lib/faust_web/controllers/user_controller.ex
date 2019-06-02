defmodule FaustWeb.UserController do
  use FaustWeb, :controller

  import FaustWeb.Accounts.UserHelper
  import Phoenix.LiveView.Controller

  alias Faust.Accounts
  alias Faust.Accounts.User
  alias Faust.Snoop
  alias FaustWeb.Accounts.{UserHelper, UserIndexLive}
  alias FaustWeb.AuthenticationHelper

  action_fallback FaustWeb.FallbackController

  def action(conn, _) do
    action_name = action_name(conn)

    args =
      if action_name in [:new, :create] do
        [conn, conn.params]
      else
        [conn, conn.params, current_user(conn)]
      end

    apply(__MODULE__, action_name, args)
  end

  def index(conn, _params, %User{} = current_user) do
    list_followee_ids_task = Task.async(Snoop, :list_followee_ids, [current_user.id])
    users_task = Task.async(Accounts, :list_users, [[:credential]])

    live_render(conn, UserIndexLive,
      session: %{
        current_user: current_user,
        list_followee_ids: Task.await(list_followee_ids_task),
        users: Task.await(users_task)
      }
    )
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Добро пожаловать, #{user.name} #{user.surname}")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, %User{} = current_user) do
    user_task = Task.async(UserHelper, :user_preloads, [current_user, id])

    args =
      if current_user.id == String.to_integer(id) do
        %{}
      else
        %{list_followee_ids: Snoop.list_followee_ids(current_user.id)}
      end

    render(
      conn,
      "show.html",
      Map.merge(%{current_user: current_user, user: Task.await(user_task)}, args)
    )
  end

  def edit(conn, %{"id" => id}, %User{} = current_user) do
    with :ok <- Bodyguard.permit(User, :edit, current_user, String.to_integer(id)) do
      user = user_preloads(current_user, id)
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, %User{} = current_user) do
    with :ok <- Bodyguard.permit(User, :update, current_user, String.to_integer(id)) do
      user = user_preloads(current_user, id)

      case Accounts.update_user(user, handle_user_params(user, user_params)) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Аккаунт обновлен")
          |> redirect(to: Routes.user_path(conn, :edit, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}, %User{} = current_user) do
    with :ok <- Bodyguard.permit(User, :delete, current_user, String.to_integer(id)) do
      {:ok, _user} = Accounts.delete_user(current_user)
      AuthenticationHelper.sign_out(conn, %{"action" => "user"})
    end
  end
end
