defmodule FaustWeb.FollowerController do
  use FaustWeb, :controller

  alias Faust.Snoop
  alias Faust.Snoop.Follower

  def action(conn, _) do
    args = [conn, conn.params, current_user(conn)]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"follower_id" => follower_id} = params, current_user) do
    with :ok <- Bodyguard.permit(Follower, :create, current_user, String.to_integer(follower_id)),
         {:ok, _follower} <-
           params |> Map.merge(%{"user_id" => current_user.id}) |> Snoop.create_follower() do
      text(conn, Jason.encode!(%{"status" => "ok", "action" => "create"}))
    else
      _ ->
        text(conn, Jason.encode!(%{"status" => "error"}))
    end
  end

  def delete(conn, %{"id" => follower_id}, current_user) do
    with %Follower{} = follower <-
           Snoop.get_follower_by(%{user_id: current_user.id, follower_id: follower_id}),
         :ok <- Bodyguard.permit(Follower, :delete, current_user, follower),
         {:ok, _follower} <- Snoop.delete_follower(follower) do
      text(conn, Jason.encode!(%{"status" => "ok", "action" => "delete"}))
    else
      _ ->
        text(conn, Jason.encode!(%{"status" => "error"}))
    end
  end
end
