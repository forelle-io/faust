defmodule FaustWeb.Accounts.User.FollowerCounterLive do
  @moduledoc false

  use Phoenix.LiveView

  alias FaustWeb.Endpoint
  alias Phoenix.LiveView.Socket
  alias Phoenix.Socket.Broadcast

  def mount(%{user: user} = session, socket) do
    user.id
    |> topic()
    |> Endpoint.subscribe()

    {:ok, assign(socket, session)}
  end

  def render(assigns) do
    ~L"""
    <%= @follower_count %>
    """
  end

  def handle_info(%Broadcast{event: "inc"} = broadcast, socket) do
    %Socket{assigns: %{follower_count: follower_count}} = socket

    {:noreply,
     assign(socket, Map.put_new(broadcast.payload, :follower_count, follower_count + 1))}
  end

  def handle_info(%Broadcast{event: "dec"} = broadcast, socket) do
    %Socket{assigns: %{follower_count: follower_count}} = socket

    {:noreply,
     assign(socket, Map.put_new(broadcast.payload, :follower_count, follower_count - 1))}
  end

  def topic(user_id) do
    "follower_counter_live:#{user_id}"
  end
end
