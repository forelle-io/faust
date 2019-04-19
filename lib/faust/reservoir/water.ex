defmodule Faust.Reservoir.Water do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Faust.Accounts.User
  alias FaustWeb.WaterPolicy

  schema "waters" do
    field :name, :string
    field :description, :string
    field :is_frozen, :boolean

    timestamps()

    belongs_to :user, User
  end

  defdelegate authorize(action, current_user, resource), to: WaterPolicy

  # Changesets -----------------------------------------------------------------

  def create_changeset(water, attrs) do
    water
    |> cast(attrs, [:name, :description, :is_frozen])
    |> validate_required([:name, :description, :is_frozen])
    |> put_assoc(:user, attrs["user"], required: true)
  end

  def update_changeset(water, attrs) do
    water
    |> cast(attrs, [:name, :description, :is_frozen])
    |> validate_required([:name, :description, :is_frozen])
  end

  # SQL запросы ----------------------------------------------------------------

  def list_water_query(user_id) do
    from w in Water,
      where: w.user_id == ^user_id
  end
end
