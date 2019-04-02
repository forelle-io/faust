defmodule FaustWeb.WithoutAuthenticationPlug do
  @moduledoc false

  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [halt: 1]

  alias Faust.Accounts.User
  alias FaustWeb.AuthenticationHelper
  alias FaustWeb.Router.Helpers, as: Router

  def init(opts), do: opts

  def call(conn, opts) do
    case AuthenticationHelper.guardian_current_resource(conn, opts[:key]) do
      %User{} = user ->
        conn
        |> redirect(to: Router.user_path(conn, :show, user))
        |> halt()

      _ ->
        conn
    end
  end
end
