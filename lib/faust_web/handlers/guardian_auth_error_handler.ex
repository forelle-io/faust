defmodule FaustWeb.GuardianAuthErrorHandler do
  @moduledoc false

  @behaviour Guardian.Plug.ErrorHandler

  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  alias Faust.Accounts.User
  alias Faust.Guardian
  alias FaustWeb.Router.Helpers, as: Router
  alias Plug.Conn

  def auth_error(%Conn{} = conn, {type, _reason}, _opts)
      when type in [:unauthorized, :unauthenticated, :invalid_token, :no_resource_found] do
    conn
    |> put_flash(:error, "Пожалуйста, авторизуйтесь")
    |> redirect(to: Router.session_path(conn, :new))
  end

  def auth_error(%Conn{} = conn, {:already_authenticated, _reason}, _opts) do
    # TODO: при расширении системы аутентификации учитывать ключ из _opts и производить
    # pattern-matсhing по полученному ресурсу с помощью Guardian из соединения
    with %User{} = user <- Guardian.Plug.current_resource(conn, key: :user) do
      redirect(conn, to: Router.user_path(conn, :show, user))
    end
  end
end
