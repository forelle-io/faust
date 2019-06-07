defmodule Faust.Fishing.Fish do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Ecto.Changeset
  alias Faust.Accounts.User
  alias Faust.Fishing
  alias Faust.Fishing.FishUser

  @regex_name ~r/\A[a-zа-я ]+\z/u

  schema "fishing.fishes" do
    field :name, :string

    many_to_many :users, User,
      join_through: FishUser,
      on_replace: :delete
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_format(:name, @regex_name)
    |> unique_constraint(:name, name: :fishing_fishes_name_index)
  end

  def update_changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_format(:name, @regex_name)
    |> unique_constraint(:name, name: :fishing_fishes_name_index)
  end

  # Changeset functions --------------------------------------------------------

  def fishes_modify_changes(%Changeset{changes: changes} = changeset) do
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

  # SQL запрос -----------------------------------------------------------------

  def list_fishes_query(ids) do
    from f in Fish,
      where: f.id in ^ids
  end
end
