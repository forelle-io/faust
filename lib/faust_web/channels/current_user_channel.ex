defmodule FaustWeb.CurrentUserChannel do
  @moduledoc false

  use FaustWeb, :channel

  alias FaustWeb.Presence

  @current_user_topic "current_user:"

  def join(@current_user_topic, _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, %{assigns: %{current_user: current_user}} = socket) do
    push(socket, "presence_state", Presence.list(socket))

    {:ok, _} =
      Presence.track(socket, current_user.id, %{
        user_id: current_user.id
      })

    {:noreply, socket}
  end
end
