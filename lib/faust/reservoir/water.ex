defmodule Faust.Reservoir.Water do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Faust.Accounts.User

  schema "waters" do
    field :name, :string
    field :description, :string
    field :is_frozen, :boolean

    timestamps()

    belongs_to :user, User
  end

  def create_changeset(water, attrs) do
    water
    |> cast(attrs, [:name, :description, :is_frozen])
    |> validate_required([:name])
  end

  def update_changeset(water, attrs) do
    water
    |> cast(attrs, [:name, :description, :is_frozen])
    |> validate_required([:name])
  end
end
