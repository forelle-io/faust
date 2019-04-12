defmodule Faust.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Faust.Accounts.Credential
  alias Faust.Fishing.Fish

  schema "users" do
    field :name, :string
    field :surname, :string
    field :birthday, :date

    timestamps()

    many_to_many :fishes, Fish, join_through: "fishes_users"

    belongs_to :credential, Credential
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :birthday])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.update_changeset/2, required: true)
  end
end
