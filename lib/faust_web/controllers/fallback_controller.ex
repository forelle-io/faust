defmodule FaustWeb.FallbackController do
  @moduledoc false

  use Phoenix.Controller

  def call(_conn, {:error, :unauthorized}) do
    raise FaustWeb.ForbiddenException
  end
end
