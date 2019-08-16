defmodule FaustWeb.SnoopFollowChannel do
  @moduledoc false

  use FaustWeb, :channel

  alias Faust.Accounts
  alias Faust.Reservoir
  alias Faust.Snoop
  alias FaustWeb.Endpoint
  alias FaustWeb.Snoop.FollowerService

  @topic_user "snoop:follow:user:"
  @topic_water "snoop:follow:water:"

  def join(@topic_user <> _follower_id, _message, socket) do
    {:ok, socket}
  end

  def join(@topic_water <> _follower_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("follow", payload, %{topic: topic} = socket) do
    topic
    |> type_and_follower_id_from_topic(payload)
    |> follow(socket)

    {:noreply, socket}
  end

  def handle_in("unfollow", payload, %{topic: topic} = socket) do
    topic
    |> type_and_follower_id_from_topic(payload)
    |> unfollow(socket)

    {:noreply, socket}
  end

  def topic_user, do: @topic_user
  def topic_water, do: @topic_water

  defp cast_follower_id(%{"id" => follower_id}, _follower_id), do: follower_id
  defp cast_follower_id(_payload, follower_id), do: String.to_integer(follower_id)

  def type_and_follower_id_from_topic(@topic_user <> follower_id, payload) do
    {:user, cast_follower_id(payload, follower_id)}
  end

  def type_and_follower_id_from_topic(@topic_water <> follower_id, payload) do
    {:water, cast_follower_id(payload, follower_id)}
  end

  def follow({type, follower_id}, %{assigns: %{current_user: current_user}} = socket) do
    {broadcast_topic, structure, count_followers_function} =
      case type do
        :user ->
          {@topic_user <> "#{follower_id}", Accounts.get_user(follower_id), :count_user_followers}

        :water ->
          {@topic_water <> "#{follower_id}", Reservoir.get_water(follower_id),
           :count_water_followers}
      end

    if apply(FollowerService, :follow, [current_user, structure]) do
      push(socket, "follow", %{follower_id: follower_id})

      Endpoint.broadcast(broadcast_topic, "new_followers_count", %{
        followers_count: apply(Snoop, count_followers_function, [follower_id])
      })
    end
  end

  def unfollow({type, follower_id}, %{assigns: %{current_user: current_user}} = socket) do
    {broadcast_topic, follower, count_followers_function} =
      case type do
        :user ->
          follower =
            Snoop.get_user_follower_by(%{user_id: current_user.id, follower_id: follower_id})

          {@topic_user <> "#{follower_id}", follower, :count_user_followers}

        :water ->
          follower =
            Snoop.get_water_follower_by(%{user_id: current_user.id, follower_id: follower_id})

          {@topic_water <> "#{follower_id}", follower, :count_water_followers}
      end

    if apply(FollowerService, :unfollow, [current_user, follower]) do
      push(socket, "unfollow", %{follower_id: follower_id})

      Endpoint.broadcast(broadcast_topic, "new_followers_count", %{
        followers_count: apply(Snoop, count_followers_function, [follower_id])
      })
    end
  end
end
