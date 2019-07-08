defmodule FaustWeb.SnoopFollowerChannel do
  @moduledoc false

  use FaustWeb, :channel

  alias Faust.Snoop
  alias FaustWeb.Endpoint
  alias FaustWeb.Snoop.FollowerService

  @snoop_follower_topic "snoop:follower:actions_user:"

  def join(@snoop_follower_topic <> _user_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in(
        "create",
        payload,
        %{topic: @snoop_follower_topic <> user_id, assigns: %{current_user: current_user}} =
          socket
      ) do
    user_id =
      case payload do
        %{"user_id" => user_id} ->
          user_id

        _ ->
          String.to_integer(user_id)
      end

    case FollowerService.follower_create(current_user, user_id) do
      :ok ->
        push(socket, "create", %{user_id: user_id})

        Endpoint.broadcast("#{@snoop_follower_topic}#{user_id}", "followers_count", %{
          followers_count: Snoop.count_user_followers(user_id)
        })

        Endpoint.broadcast("#{@snoop_follower_topic}#{current_user.id}", "followee_count", %{
          followee_count: Snoop.count_user_followee(current_user.id)
        })

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  def handle_in(
        "delete",
        payload,
        %{topic: @snoop_follower_topic <> user_id, assigns: %{current_user: current_user}} =
          socket
      ) do
    user_id =
      case payload do
        %{"user_id" => user_id} ->
          user_id

        _ ->
          String.to_integer(user_id)
      end

    case FollowerService.follower_delete(current_user, user_id) do
      :ok ->
        push(socket, "delete", %{user_id: user_id})

        Endpoint.broadcast("#{@snoop_follower_topic}#{user_id}", "followers_count", %{
          followers_count: Snoop.count_user_followers(user_id)
        })

        Endpoint.broadcast("#{@snoop_follower_topic}#{current_user.id}", "followee_count", %{
          followee_count: Snoop.count_user_followee(current_user.id)
        })

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end
end
