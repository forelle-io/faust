defmodule FaustWeb.LayoutView do
  use FaustWeb, :view

  def logotype_path(conn) do
    Routes.static_path(conn, "/images/logotype.png")
  end
end
