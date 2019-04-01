defmodule FaustWeb.AuthenticationHelper do
  @moduledoc false

  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  import Plug.Conn, only: [assign: 3]

  alias Faust.Accounts.{Credential}
  alias Faust.Guardian
  alias Faust.Repo
  alias FaustWeb.Router.Helpers, as: Router

  def sign_in(conn, %{"credential" => params}) do
    credential = Repo.get_by(Credential, unique: params["unique"])

    if credential && Bcrypt.verify_pass(params["password"], credential.password_hash) do
      association = params["association"]

      case prepare_current_resource(credential, association) do
        {:ok, current_resource} ->
          redirect_to =
            apply(Router, String.to_atom("#{association}_path"), [conn, :show, current_resource])

          conn
          |> Guardian.Plug.sign_in(current_resource, %{"type" => "access"},
            key: String.to_atom(association)
          )
          |> assign(String.to_atom("current_#{association}"), current_resource)
          |> redirect(to: redirect_to)

        _ ->
          redirect(conn, to: "/")
      end
    else
      conn
      |> put_flash(:error, "Bad credential params")
      |> redirect(to: "/")
    end
  end

  def sign_in(conn, _), do: redirect(conn, to: "/")

  def sign_out(conn, %{"action" => action})
      when action in ["user", "credential", "chief"] do
    conn
    |> Faust.Guardian.Plug.sign_out(key: String.to_atom(action))
    |> redirect(to: "/")
  end

  def sign_out(conn, _), do: redirect(conn, to: "/")

  # Private functions ----------------------------------------------------------

  defp prepare_current_resource(%Credential{} = credential, association)
       when association in ["user", "organization", "chief"] do
    mapped_struct =
      credential
      |> Repo.preload(String.to_atom(association))
      |> Map.from_struct()

    case for {key, value} <- mapped_struct, into: %{}, do: {Atom.to_string(key), value} do
      %{^association => current_resource} when not is_nil(current_resource) ->
        {:ok, struct(current_resource, credential: credential)}

      _ ->
        {:error, :not_found_association}
    end
  end

  defp prepare_current_resource(_, _), do: {:error, :unknown_association}
end
