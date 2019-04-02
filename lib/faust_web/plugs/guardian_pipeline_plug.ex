defmodule FaustWeb.GuardianPipelinePlug do
  @moduledoc false

  alias Guardian.Plug.{Pipeline, VerifySession, LoadResource}

  use Pipeline,
    otp_app: :faust,
    module: Faust.Guardian,
    error_handler: FaustWeb.AuthenticationHelper

  plug VerifySession, key: :user
  plug LoadResource, key: :user, allow_blank: true
end
