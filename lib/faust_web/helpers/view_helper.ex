defmodule FaustWeb.ViewHelper do
  @moduledoc false

  def active_href_class(conn, name) do
    if name == Phoenix.Controller.current_path(conn) do
      "active"
    else
      ""
    end
  end
end
