defmodule FaustWeb.AuthenticationHelper do
  @moduledoc false

  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  alias Faust.Accounts.{Credential}
  alias Faust.Guardian
  alias Faust.Repo
  alias FaustWeb.Router.Helpers, as: Router
  alias Plug.Conn

  def sign_in(%Conn{} = conn, %{"credential" => params}) do
    credential = Repo.get_by(Credential, unique: params["unique"])

    if credential && Bcrypt.verify_pass(params["password"], credential.password_hash) do
      association = params["association"]

      case prepare_current_resource(credential, association) do
        {:ok, current_resource} ->
          redirect_to =
            apply(Router, String.to_atom("#{association}_path"), [conn, :show, current_resource])

          conn
          |> Guardian.Plug.sign_in(current_resource, %{}, key: String.to_atom(association))
          |> redirect(to: redirect_to)

        _ ->
          redirect(conn, to: "/")
      end
    else
      conn
      |> put_flash(:error, "Bad credential params")
      |> redirect(to: Router.session_path(conn, :new))
    end
  end

  def sign_in(%Conn{} = conn, _), do: redirect(conn, to: "/")

  def sign_out(%Conn{} = conn, %{"action" => action})
      when action in ["user", "credential", "chief"] do
    conn
    |> Faust.Guardian.Plug.sign_out(key: String.to_atom(action))
    |> redirect(to: "/")
  end

  def sign_out(%Conn{} = conn, _), do: redirect(conn, to: "/")

  def auth_error(%Conn{} = conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, "Please, sign in")
    |> redirect(to: Router.session_path(conn, :new))
  end

  def current_user(%Conn{} = conn) do
    guardian_current_resource(conn, :user)
  end

  def current_organization(%Conn{} = conn) do
    guardian_current_resource(conn, :organization)
  end

  def current_chief(%Conn{} = conn) do
    guardian_current_resource(conn, :chief)
  end

  def guardian_current_resource(%Conn{} = conn, key)
      when key in [:user, :organization, :chief] do
    Guardian.Plug.current_resource(conn, key: key)
  end

  def guardian_current_resource(_, _), do: nil

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
