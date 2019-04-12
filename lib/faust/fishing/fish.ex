defmodule Faust.Fishing.Fish do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias __MODULE__
  alias Faust.Accounts.User

  schema "fishes" do
    field :name, :string

    many_to_many :users, User, join_through: "fishes_users"
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def update_changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
