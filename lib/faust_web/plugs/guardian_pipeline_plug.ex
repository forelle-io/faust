defmodule FaustWeb.GuardianPipelinePlug do
  @moduledoc false

  alias Guardian.Plug.{LoadResource, Pipeline, VerifyHeader, VerifySession}

  use Pipeline,
    otp_app: :faust,
    module: Faust.Guardian,
    error_handler: FaustWeb.GuardianAuthErrorHandler

  plug VerifySession, key: :user
  plug VerifyHeader, key: :user
  plug LoadResource, key: :user, allow_blank: true
end
