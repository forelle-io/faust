defmodule FaustWeb.PageController do
  use FaustWeb, :controller

  alias Faust.Accounts
  alias Faust.Accounts.User

  def index(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "index.html", changeset: changeset, layout: false)
  end
end
