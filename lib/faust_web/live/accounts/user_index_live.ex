defmodule FaustWeb.Accounts.UserIndexLive do
  @moduledoc false

  use Phoenix.LiveView
  use FaustWeb.FollowerEventsMacros

  alias FaustWeb.UserView

  def mount(session, socket) do
    {:ok, assign(socket, session)}
  end

  def render(assigns) do
    UserView.render("index.html", assigns)
  end
end
