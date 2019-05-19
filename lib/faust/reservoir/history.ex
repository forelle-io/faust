defmodule Faust.Reservoir.History do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Faust.Reservoir.Water
  alias FaustWeb.Reservoir.HistoryPolicy

  @types ["создание", "реконструкция", "зарыбление", "закрытие"]

  schema "reservoir.histories" do
    field :type, :string
    field :description, :string

    timestamps()

    belongs_to :water, Water
  end

  defdelegate authorize(action, current_user, resource), to: HistoryPolicy

  def types, do: @types

  # Changesets -----------------------------------------------------------------

  def create_changeset(history, attrs) do
    history
    |> cast(attrs, [:type, :description])
    |> validate_required([:type])
    |> validate_inclusion(:type, @types)
    |> put_assoc(:water, attrs["water"], required: true)
  end

  def update_changeset(history, attrs) do
    history
    |> cast(attrs, [:type, :description])
    |> validate_required([:type])
    |> validate_inclusion(:type, @types)
  end

  # SQL запросы ----------------------------------------------------------------

  def list_history_query(water_id) do
    from h in History,
      where: h.water_id == ^water_id
  end
end
