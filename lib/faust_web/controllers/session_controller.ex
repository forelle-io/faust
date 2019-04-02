defmodule FaustWeb.SessionController do
  use FaustWeb, :controller

  alias Faust.Accounts
  alias Faust.Accounts.Credential
  alias FaustWeb.AuthenticationHelper

  def new(conn, _params) do
    changeset = Accounts.session_credential(%Credential{})
    render(conn, "new.html", changeset: changeset, association: :user)
  end

  def create(conn, params), do: AuthenticationHelper.sign_in(conn, params)

  def delete(conn, params), do: AuthenticationHelper.sign_out(conn, params)
end
