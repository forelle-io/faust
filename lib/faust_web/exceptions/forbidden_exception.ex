defmodule FaustWeb.ForbiddenException do
  @moduledoc false

  defexception message: "You don't have permission to access", plug_status: 403
end
