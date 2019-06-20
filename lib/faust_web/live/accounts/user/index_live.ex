defmodule FaustWeb.Accounts.User.IndexLive do
  @moduledoc false

  use Phoenix.LiveView

  alias Faust.Accounts
  alias FaustWeb.Accounts.User.FollowerCounterLive
  alias FaustWeb.Endpoint
  alias FaustWeb.Snoop.FollowerService
  alias FaustWeb.UserView
  alias Phoenix.LiveView.Socket

  def mount(session, socket) do
    {:ok, assign(socket, Map.merge(session, %{filter: nil, loading: false}))}
  end

  def render(assigns) do
    UserView.render("index.html", assigns)
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
        Endpoint.broadcast_from(self(), FollowerCounterLive.topic(value), "inc", %{})

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
        Endpoint.broadcast_from(self(), FollowerCounterLive.topic(value), "dec", %{})

        {:noreply, assign(socket, list_followee_ids: list_followee_ids)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  def handle_event("search", %{"filter" => filter}, %{assigns: %{loading: true}} = socket) do
    {:noreply, assign(socket, filter: filter)}
  end

  def handle_event("search", %{"filter" => filter}, %{assigns: %{loading: false}} = socket) do
    socket =
      case filter do
        %{"search" => _search, "sex" => _sex} ->
          socket
          |> assign(:filter, filter)
          |> assign(:timer_ref, Process.send_after(self(), :search, 500))
          |> assign(:loading, true)

        _ ->
          list_users = Accounts.list_users([:credential])
          assign(socket, :users, list_users)
      end

    {:noreply, socket}
  end

  def handle_info(:search, %{assigns: %{filter: filter}} = socket) do
    socket =
      socket
      |> assign(:filter, filter)
      |> assign(:loading, false)
      |> assign(:users, Accounts.list_users_by_filter(filter))

    {:noreply, socket}
  end
end
