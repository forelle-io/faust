defmodule FaustWeb.UserView do
  use FaustWeb, :view

  import Phoenix.Controller, only: [action_name: 1]

  alias Faust.Accounts.User
  alias Plug.Conn

  def follower_link(%Conn{} = conn, [], %User{id: id}) do
    class = follower_css_class(conn, "btn btn-outline-primary")
    link("Подписаться", to: "#", class: class, id: id, onclick: "follow_user(this);")
  end

  def follower_link(%Conn{} = conn, current_followee_ids, %User{id: id})
      when is_list(current_followee_ids) do
    if Enum.member?(current_followee_ids, id) do
      link("Отписаться",
        to: "#",
        class: follower_css_class(conn, "btn btn-primary"),
        id: id,
        onclick: "follow_user(this);"
      )
    else
      link("Подписаться",
        to: "#",
        class: follower_css_class(conn, "btn btn-outline-primary"),
        id: id,
        onclick: "follow_user(this);"
      )
    end
  end

  defp follower_css_class(%Conn{} = conn, class) when is_bitstring(class) do
    case action_name(conn) do
      :show ->
        "#{class} btn-lg btn-block"

      _ ->
        class
    end
  end
end
