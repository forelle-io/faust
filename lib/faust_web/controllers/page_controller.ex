defmodule FaustWeb.PageController do
  use FaustWeb, :controller

  def index(conn, _params) do
    # IO.inspect conn
    render(conn, "index.html")
  end
end
