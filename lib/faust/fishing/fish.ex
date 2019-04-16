defmodule Faust.Fishing.Fish do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias Faust.Accounts.User
  alias Faust.Fishing.Fish

  schema "fishes" do
    field :name, :string, default: false

    many_to_many :users, User, join_through: "fishes_users", on_replace: :delete
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def update_changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  # SQL запрос -----------------------------------------------------------------

  def list_fishes_query(ids) do
    from f in Fish,
      where: f.id in ^ids
  end
end
