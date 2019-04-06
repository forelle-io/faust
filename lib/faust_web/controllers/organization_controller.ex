defmodule FaustWeb.OrganizationController do
  use FaustWeb, :controller

  alias Faust.Accounts

  def index(conn, _params) do
    organization = Accounts.list_organization()
    render(conn, "index.html", organization: organization)
  end

  def show(conn, %{"id" => id}) do
    organization = Accounts.get_organization!(id)
    render(conn, "show.html", organization: organization)
  end
end
