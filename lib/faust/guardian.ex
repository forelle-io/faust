defmodule Faust.Guardian do
  @moduledoc false

  use Guardian, otp_app: :faust

  alias Faust.Accounts

  def subject_for_token(resource, _claims) do
    prefix_from_subject = fetch_prefix_from_subject(resource)
    {:ok, "#{prefix_from_subject}:#{resource.id}"}
  end

  def resource_from_claims(%{"sub" => "user:" <> id}) do
    handle_claims(id, "user")
  end

  def resource_from_claims(%{"sub" => "organization:" <> id}) do
    handle_claims(id, "organization")
  end

  def resource_from_claims(%{"sub" => "chief:" <> id}) do
    handle_claims(id, "chief")
  end

  # Private functions ----------------------------------------------------------

  defp fetch_prefix_from_subject(resource) do
    resource.__struct__
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
    |> String.downcase()
  end

  defp handle_claims(id, action) when action in ["user", "organization", "chief"] do
    case apply(Accounts, String.to_atom("get_#{action}"), [id]) do
      nil ->
        {:error, :not_found}

      resource ->
        {:ok, resource}
    end
  end

  # defp handle_claims(id, action), do: "The claims not found (action: #{action}, id: #{id})"
  defp handle_claims(_, _), do: {:error, :not_found}
end
