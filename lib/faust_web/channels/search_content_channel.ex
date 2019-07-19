defmodule FaustWeb.SearchContentChannel do
  @moduledoc false

  use FaustWeb, :channel

  import Phoenix.View, only: [render_to_string: 3]

  alias Faust.Accounts
  alias Faust.Snoop
  alias FaustWeb.UserView

  @search_content_topic "search:content:"

  def join(@search_content_topic, _payload, socket) do
    {:ok, assign(socket, :search, %{params: nil, loading: false})}
  end

  def handle_in("search", payload, %{assigns: %{search: %{loading: true} = search}} = socket) do
    search = %{search | params: payload}

    {:noreply, assign(socket, :search, search)}
  end

  def handle_in("search", payload, %{assigns: %{search: %{loading: false} = search}} = socket) do
    search = %{search | params: payload, loading: true}

    socket =
      socket
      |> assign(:search, search)
      |> assign(:timer_ref, Process.send_after(self(), "delayed_search", 1500))

    {:noreply, socket}
  end

  def handle_info(
        "delayed_search",
        %{assigns: %{search: %{params: params} = payload, current_user: current_user}} = socket
      ) do
    users_task = Task.async(Accounts, :list_users_by_filter, [params])
    list_followee_ids = Snoop.list_followee_ids(current_user.id)

    content =
      UserView
      |> render_to_string("_users_list.html",
        current_user: current_user,
        list_followee_ids: list_followee_ids,
        users: Task.await(users_task)
      )

    push(socket, "delayed_search", %{content: content})

    {:noreply, assign(socket, :search, %{payload | loading: false})}
  end
end
