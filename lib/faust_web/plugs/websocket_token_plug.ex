defmodule FaustWeb.WebsocketTokenPlug do
  @moduledoc false

  import Plug.Conn

  alias Faust.Accounts.User
  alias Faust.Crypto
  alias FaustWeb.AuthenticationHelper
  alias Phoenix.Token

  def init(default), do: default

  # TODO: При использовании плага для генерации токена для вебсокета, данную
  # функцию необходимо расширить для других ресурсов
  def call(%Plug.Conn{} = conn, default) do
    with [key: :user] <- default,
         %User{id: user_id} <- AuthenticationHelper.current_user(conn) do
      websocket_token = Token.sign(conn, Crypto.secret_key_base(), "user_id:#{user_id}")
      assign(conn, :websocket_token, websocket_token)
    else
      _ ->
        conn
    end
  end
end
