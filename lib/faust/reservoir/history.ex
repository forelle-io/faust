defmodule Faust.Reservoir.History do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Faust.Reservoir.Water

  schema "histories" do
    field :type, :string
    field :description, :string

    timestamps()

    belongs_to :water, Water
  end

  def types() do
    types = ["создание", "реконструкция", "зарыбление", "закрытие"]
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(history, attrs) do
    history
    |> cast(attrs, [:type, :description])
    |> validate_required([:type, :description])
    |> put_assoc(:water, attrs["water"], required: true)
  end

  def update_changeset(history, attrs) do
    history
    |> cast(attrs, [:type, :description])
    |> validate_required([:type, :description])
  end

  # SQL запросы ----------------------------------------------------------------

  def list_history_query(water_id) do
    from h in History,
      where: h.water_id == ^water_id
  end

end
