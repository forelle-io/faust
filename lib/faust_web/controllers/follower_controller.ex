defmodule FaustWeb.FollowerController do
  use FaustWeb, :controller

  alias Faust.Accounts.User
  alias Faust.Snoop
  alias Faust.Snoop.Follower

  def action(conn, _) do
    args = [conn, conn.params, current_user(conn)]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"follower_id" => _follower_id} = params, %User{id: id}) do
    # TODO: Написать Snoop.FollowerPolicy и использовать здесь
    follower =
      params
      |> Map.merge(%{"user_id" => id})
      |> Snoop.create_follower()

    case follower do
      {:ok, _follower} ->
        text(conn, Jason.encode!(%{"status" => "ok", "action" => "create"}))

      {:error, %Ecto.Changeset{} = _changeset} ->
        text(conn, Jason.encode!(%{"status" => "error"}))
    end
  end

  def delete(conn, %{"id" => follower_id}, %User{id: id}) do
    # TODO: Написать Snoop.FollowerPolicy и использовать здесь
    with %Follower{} = follower <-
           Snoop.get_follower_by(%{user_id: id, follower_id: follower_id}),
         {:ok, _follower} <- Snoop.delete_follower(follower) do
      text(conn, Jason.encode!(%{"status" => "ok", "action" => "delete"}))
    else
      _ ->
        text(conn, Jason.encode!(%{"status" => "error"}))
    end
  end
end
