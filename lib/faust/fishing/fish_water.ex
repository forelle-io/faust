defmodule Faust.Fishing.FishWater do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Fishing.Fish
  alias Faust.Reservoir.Water

  @primary_key false

  schema "fishing.fishes_waters" do
    belongs_to(:fishes, Fish)
    belongs_to(:waters, Water)
  end
end
