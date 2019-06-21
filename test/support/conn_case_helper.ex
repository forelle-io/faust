defmodule FaustWeb.ConnCaseHelper do
  @moduledoc """
  Вспомогательный модуль для тестирования соединений
  """

  alias Faust.Guardian
  alias Plug.Conn

  @doc """
  Создание авторизованного соединения для ресурса через генерацию
  токена безопасности Guardian, который должен быть добавлен в заголовок
  соединения
  """
  def authorize_conn(%Conn{} = conn, resource) do
    case Guardian.encode_and_sign(resource) do
      {:ok, token, _} ->
        Conn.put_req_header(conn, "authorization", "bearer: " <> token)

      _ ->
        conn
    end
  end

  @doc """
  Использование базовой аутентификации
  """
  def using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> Conn.put_req_header("authorization", header_content)
  end
end
