defmodule FaustWeb.BasicAuthPlug do
  @moduledoc false

  import Plug.Conn, only: [halt: 1]

  def authenticate(conn, username, password) do
    cond do
      Enum.member?([:dev, :test], Mix.env()) ->
        conn

      fetch_basic_auth_config(:username) == username and
          fetch_basic_auth_config(:password) == password ->
        conn

      true ->
        halt(conn)
    end
  end

  defp fetch_basic_auth_config(key) when is_atom(key) do
    Application.get_env(:faust, :basic_auth)[key]
  end
end
