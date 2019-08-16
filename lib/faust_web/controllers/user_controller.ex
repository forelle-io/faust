defmodule FaustWeb.UserController do
  use FaustWeb, :controller

  import FaustWeb.Accounts.UserHelper

  alias Faust.Accounts
  alias Faust.Accounts.User
  alias Faust.Snoop
  alias FaustWeb.Accounts.UserHelper
  alias FaustWeb.AuthenticationHelper

  action_fallback FaustWeb.FallbackController

  def action(conn, _) do
    action_name = action_name(conn)

    args =
      cond do
        action_name in [:new, :create] ->
          [conn, conn.params]

        "XMLHttpRequest" in get_req_header(conn, "x-requested-with") and action_name == :update ->
          [conn, conn.params, current_user(conn)]

        true ->
          [conn, conn.params, current_user(conn)]
      end

    apply(__MODULE__, action_name, args)
  end

  def index(conn, params, %User{} = current_user) do
    list_followee_ids_task = Task.async(Snoop, :list_user_followee_ids, [current_user.id])
    list_users_page = Accounts.list_users_by_params(params, [:credential])

    render(conn, "index.html",
      params: params,
      current_user: current_user,
      list_followee_ids: Task.await(list_followee_ids_task),
      list_users_page: list_users_page
    )
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        redirect(conn, to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, %User{} = current_user) do
    followee_count_task = Task.async(Snoop, :count_user_followee, [id])
    followers_count_task = Task.async(Snoop, :count_user_followers, [id])

    user = UserHelper.user_preloads(current_user, id)

    args =
      if current_user.id == String.to_integer(id) do
        %{}
      else
        %{list_followee_ids: Snoop.list_user_followee_ids(current_user.id)}
      end

    render(
      conn,
      "show.html",
      Map.merge(
        %{
          current_user: current_user,
          user: user,
          followee_count: Task.await(followee_count_task),
          followers_count: Task.await(followers_count_task)
        },
        args
      )
    )
  end

  def edit(conn, %{"id" => id}, %User{} = current_user) do
    with :ok <- Bodyguard.permit(User, :edit, current_user, String.to_integer(id)) do
      user = user_preloads(current_user, id)
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(
        conn,
        %{"id" => id, "user" => %{"avatar" => %Plug.Upload{}} = user_params},
        %User{} = current_user
      ) do
    with :ok <- Bodyguard.permit(User, :update, current_user, String.to_integer(id)),
         user <- user_preloads(current_user, id) do
      case Accounts.update_user(user, handle_user_params(user, user_params)) do
        {:ok, _user} ->
          text(conn, "ok")

        {:error, %Ecto.Changeset{}} ->
          text(conn, "error")
      end
    else
      _ ->
        text(conn, "error")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, %User{} = current_user) do
    with :ok <- Bodyguard.permit(User, :update, current_user, String.to_integer(id)),
         user <- user_preloads(current_user, id) do
      case Accounts.update_user(user, handle_user_params(user, user_params)) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Аккаунт обновлен")
          |> redirect(to: Routes.user_path(conn, :edit, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html",
            user: user,
            changeset: changeset
          )
      end
    end
  end

  def update(conn, _params, %User{} = current_user) do
    redirect(conn, to: Routes.user_path(conn, :edit, current_user))
  end

  def delete(conn, %{"id" => id}, %User{} = current_user) do
    with :ok <- Bodyguard.permit(User, :delete, current_user, String.to_integer(id)) do
      {:ok, _user} = Accounts.delete_user(current_user)
      AuthenticationHelper.sign_out(conn, %{"action" => "user"})
    end
  end
end
