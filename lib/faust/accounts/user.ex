defmodule Faust.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Faust.Accounts.Credential
  alias Faust.Fishing
  alias Faust.Fishing.Fish
  alias FaustWeb.UserPolicy

  schema "users" do
    field :name, :string
    field :surname, :string
    field :birthday, :date

    field :fishes_ids, :any, virtual: true

    timestamps()

    many_to_many :fishes, Fish, join_through: "fishes_users", on_replace: :delete

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
    |> cast(attrs, [:name, :surname, :birthday, :fishes_ids])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.update_changeset/2, required: true)
    |> fishes_pipeline()
  end

  # Приватные функции ----------------------------------------------------------

  defp fishes_pipeline(%Changeset{changes: changes} = changeset) do
    case changes do
      %{fishes_ids: nil} ->
        changeset

      %{fishes_ids: []} ->
        put_assoc(changeset, :fishes, [])

      %{fishes_ids: fishes_ids} ->
        put_assoc(changeset, :fishes, Fishing.list_fishes(fishes_ids))

      _ ->
        changeset
    end
  end
end
