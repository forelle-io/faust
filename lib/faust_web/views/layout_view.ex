defmodule FaustWeb.LayoutView do
  use FaustWeb, :view

  import FaustWeb.AuthenticationHelper, only: [authenticated_user?: 1, current_user: 1]

  alias Plug.Conn

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
