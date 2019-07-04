defmodule FaustWeb.SnoopFollowerChannel do
  @moduledoc false

  use FaustWeb, :channel

  alias Faust.Snoop
  alias FaustWeb.Snoop.FollowerService
  alias FaustWeb.Endpoint

  @actions_topic "snoop:follower:actions_user:"

  def join(@actions_topic <> _user_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in(
        "create",
        message,
        %{topic: @actions_topic <> user_id, assigns: %{current_user: current_user}} = socket
      ) do
    user_id =
      case message do
        %{"user_id" => user_id} ->
          user_id

        _ ->
          String.to_integer(user_id)
      end

    case FollowerService.follower_create(current_user, user_id) do
      :ok ->
        push(socket, "create", %{user_id: user_id})

        Endpoint.broadcast("#{@actions_topic}#{user_id}", "followers_count", %{
          followers_count: Snoop.count_user_followers(user_id)
        })

        Endpoint.broadcast("#{@actions_topic}#{current_user.id}", "followee_count", %{
          followee_count: Snoop.count_user_followee(current_user.id)
        })

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  def handle_in(
        "delete",
        message,
        %{topic: @actions_topic <> user_id, assigns: %{current_user: current_user}} = socket
      ) do
    user_id =
      case message do
        %{"user_id" => user_id} ->
          user_id

        _ ->
          String.to_integer(user_id)
      end

    case FollowerService.follower_delete(current_user, user_id) do
      :ok ->
        push(socket, "delete", %{user_id: user_id})

        Endpoint.broadcast("#{@actions_topic}#{user_id}", "followers_count", %{
          followers_count: Snoop.count_user_followers(user_id)
        })

        Endpoint.broadcast("#{@actions_topic}#{current_user.id}", "followee_count", %{
          followee_count: Snoop.count_user_followee(current_user.id)
        })

        {:noreply, socket}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end
end
