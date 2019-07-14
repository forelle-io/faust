defmodule FaustWeb.LayoutView do
  use FaustWeb, :view

  import FaustWeb.AuthenticationHelper, only: [authenticated_user?: 1, current_user: 1]

  alias Plug.Conn

  def active_href_navigation_class(%Conn{} = conn, current_path) do
    if current_path == Phoenix.Controller.current_path(conn) do
      "active-href-navigation-class"
    else
      ""
    end
  end

  def active_href_dropdown_class(%Conn{} = conn, current_path) do
    if current_path == Phoenix.Controller.current_path(conn) do
      "active"
    else
      ""
    end
  end

  def clickable_logotype(%Conn{} = conn) do
    conn
    |> Routes.static_path("/images/logotype.png")
    |> img_tag(height: 72)
    |> link(
      to:
        if(authenticated_user?(conn),
          do: Routes.user_path(conn, :show, current_user(conn)),
          else: "/"
        )
    )
  end
end
