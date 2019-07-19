defmodule Faust.Repo.Migrations.IsFrozenFalseInReservoirWaters do
  use Ecto.Migration

  alias Faust.Reservoir.Water

  def change do
    reservoir_waters_tn = Faust.fetch_table_name(%Water{})

    alter table(reservoir_waters_tn) do
      modify :is_frozen, :boolean, default: false
    end
  end
end
