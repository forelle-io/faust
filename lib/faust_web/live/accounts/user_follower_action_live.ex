defmodule FaustWeb.Accounts.UserFollowerActionLive do
  @moduledoc false

  use Phoenix.LiveView
  use FaustWeb.FollowerEventsMacros

  alias FaustWeb.UserView

  def mount(session, socket) do
    {:ok, assign(socket, session)}
  end

  def render(assigns) do
    UserView.render("_follower_action.html", assigns)
  end
end
