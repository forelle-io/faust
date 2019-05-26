defmodule FaustWeb.UserView do
  use FaustWeb, :view

  alias Faust.Accounts.User

  def follower_link(current_followee_ids, %User{id: id}) when is_list(current_followee_ids) do
    if Enum.member?(current_followee_ids, id) do
      link("Отписаться",
        to: "#",
        class: "btn btn-primary",
        id: id,
        onclick: "follow_user(\"#{Plug.CSRFProtection.get_csrf_token()}\", this);",
        data: [action: "unfollow"]
      )
    else
      link("Подписаться",
        to: "#",
        class: "btn btn-outline-primary",
        id: id,
        onclick: "follow_user(\"#{Plug.CSRFProtection.get_csrf_token()}\", this);",
        data: [action: "follow"]
      )
    end
  end
end
