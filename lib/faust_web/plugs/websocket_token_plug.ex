defmodule FaustWeb.WebsocketTokenPlug do
  @moduledoc false

  import Plug.Conn

  alias Faust.Accounts.User
  alias FaustWeb.AuthenticationHelper
  alias Phoenix.Token

  def init(default), do: default

  # TODO: При использовании плага для генерации токена для вебсокета, данную
  # функцию необходимо расширить для других ресурсов
  def call(%Plug.Conn{} = conn, default) do
    with [key: :user] <- default,
         %User{id: user_id} <- AuthenticationHelper.current_user(conn) do
      secret_key_base =
        :faust
        |> Application.get_env(FaustWeb.Endpoint)
        |> Keyword.fetch!(:secret_key_base)

      websocket_token = Token.sign(conn, secret_key_base, "user_id:#{user_id}")
      assign(conn, :websocket_token, websocket_token)
    else
      _ ->
        conn
    end
  end
end
