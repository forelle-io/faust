defmodule Faust.Fishing.TechniqueWater do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Fishing.Technique
  alias Faust.Reservoir.Water

  @primary_key false

  schema "fishing.techniques_waters" do
    belongs_to(:techniques, Technique)
    belongs_to(:waters, Water)
  end
end
