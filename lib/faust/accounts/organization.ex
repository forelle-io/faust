defmodule Faust.Accounts.Organization do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Faust.Accounts.Credential

  @regex_name ~r/\A[a-zA-Zа-яА-Я ]+\z/u

  schema "accounts.organizations" do
    field :name, :string
    field :description, :string
    field :address, :string

    timestamps()

    belongs_to :credential, Credential
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :address, :description])
    |> validate_format(:name, @regex_name)
    |> validate_required([:name, :address])
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def update_changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :address, :description])
    |> validate_format(:name, @regex_name)
    |> validate_required([:name, :address])
    |> cast_assoc(:credential, with: &Credential.update_changeset/2, required: true)
  end
end
