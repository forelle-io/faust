defmodule FaustWeb.PageController do
  use FaustWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
