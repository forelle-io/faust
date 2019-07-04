defmodule FaustWeb.BasicAuthPlug do
  @moduledoc false

  import Plug.Conn, only: [halt: 1]

  def authenticate(conn, username, password) do
    if is_valid?(username, password), do: conn, else: halt(conn)
  end

  def is_valid?(username, password) do
    Enum.all?([{:username, username}, {:password, password}], fn {k, v} ->
      basic_auth_config(k) == v
    end)
  end

  defp basic_auth_config(key) when is_atom(key) do
    Application.get_env(:faust, :basic_auth)[key]
  end
end
