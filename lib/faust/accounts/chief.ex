defmodule Faust.Accounts.Chief do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Faust.Accounts.Credential

  schema "chiefs" do
    timestamps()

    belongs_to :credential, Credential
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(chief, attrs) do
    chief
    |> cast(attrs, [])
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def update_changeset(chief, attrs) do
    chief
    |> cast(attrs, [])
    |> cast_assoc(:credential, with: &Credential.update_changeset/2, required: true)
  end
end
