defmodule Faust.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Faust.Accounts.Credential
  alias Faust.Fishing.{Fish, Technique}
  alias Faust.Reservoir.Water
  alias FaustWeb.UserPolicy

  schema "users" do
    field :name, :string
    field :surname, :string
    field :birthday, :date

    field :fishes_ids, :any, virtual: true
    field :techniques_ids, :any, virtual: true

    timestamps()

    has_many :waters, Water

    many_to_many :fishes, Fish, join_through: "fishes_users", on_replace: :delete
    many_to_many :techniques, Technique, join_through: "techniques_users", on_replace: :delete

    belongs_to :credential, Credential
  end

  defdelegate authorize(action, current_user, resource), to: UserPolicy

  # Changesets -----------------------------------------------------------------

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :birthday, :fishes_ids, :techniques_ids])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.update_changeset/2, required: true)
    |> Fish.fishes_pipeline()
    |> Technique.techniques_pipeline()
  end
end
