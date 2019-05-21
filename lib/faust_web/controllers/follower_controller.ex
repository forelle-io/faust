defmodule FaustWeb.FollowerController do
  use FaustWeb, :controller

  import Plug.Conn, only: [get_req_header: 2]

  alias Faust.Snoop
  alias Faust.Snoop.Follower

  def action(conn, _) do
    args = [conn, conn.params, current_user(conn)]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"follower_id" => follower_id} = params, current_user) do
    follower_id = String.to_integer(follower_id)

    with :ok <- Bodyguard.permit(Follower, :create, current_user, follower_id),
         {:ok, _follower} <-
           params |> Map.merge(%{"user_id" => current_user.id}) |> Snoop.create_follower() do
      if is_xml_http_request?(conn) do
        text(conn, Jason.encode!(%{"status" => "ok", "action" => "create"}))
      else
        redirect(conn, to: Routes.user_path(conn, :show, follower_id))
      end
    else
      _ ->
        if is_xml_http_request?(conn) do
          text(conn, Jason.encode!(%{"status" => "error"}))
        else
          conn
          |> put_flash(:error, "Произошла ошибка")
          |> redirect(to: Routes.user_path(conn, :show, follower_id))
        end
    end
  end

  def delete(conn, %{"id" => follower_id}, current_user) do
    with %Follower{} = follower <-
           Snoop.get_follower_by(%{user_id: current_user.id, follower_id: follower_id}),
         :ok <- Bodyguard.permit(Follower, :delete, current_user, follower),
         {:ok, _follower} <- Snoop.delete_follower(follower) do
      if is_xml_http_request?(conn) do
        text(conn, Jason.encode!(%{"status" => "ok", "action" => "delete"}))
      else
        redirect(conn, to: Routes.user_path(conn, :show, follower_id))
      end
    else
      _ ->
        if is_xml_http_request?(conn) do
          text(conn, Jason.encode!(%{"status" => "error"}))
        else
          conn
          |> put_flash(:error, "Произошла ошибка")
          |> redirect(to: Routes.user_path(conn, :show, follower_id))
        end
    end
  end

  defp is_xml_http_request?(conn) do
    case get_req_header(conn, "x-requested-with") do
      ["XMLHttpRequest"] -> true
      _ -> false
    end
  end
end
