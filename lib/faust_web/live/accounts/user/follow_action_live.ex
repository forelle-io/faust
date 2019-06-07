defmodule FaustWeb.Accounts.User.FollowActionLive do
  @moduledoc false

  use Phoenix.LiveView

  alias FaustWeb.Accounts.User.FollowerCounterLive
  alias FaustWeb.Endpoint
  alias FaustWeb.Snoop.FollowerService
  alias FaustWeb.UserView

  def mount(session, socket) do
    {:ok, assign(socket, session)}
  end

  def render(assigns) do
    UserView.render("_follower_action.html", assigns)
  end

  def handle_event(
        "follower_create",
        value,
        %{assigns: %{current_user: current_user, list_followee_ids: list_followee_ids}} = socket
      ) do
    case FollowerService.follower_create(
           current_user,
           list_followee_ids,
           value |> String.to_integer()
         ) do
      {:ok, list_followee_ids} ->
        Endpoint.broadcast(FollowerCounterLive.topic(value), "inc", %{})

        {:noreply, assign(socket, list_followee_ids: list_followee_ids)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  def handle_event(
        "follower_delete",
        value,
        %{assigns: %{current_user: current_user, list_followee_ids: list_followee_ids}} = socket
      ) do
    case FollowerService.follower_delete(
           current_user,
           list_followee_ids,
           value |> String.to_integer()
         ) do
      {:ok, list_followee_ids} ->
        FaustWeb.Endpoint.broadcast(FollowerCounterLive.topic(value), "dec", %{})

        {:noreply, assign(socket, list_followee_ids: list_followee_ids)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end
end
