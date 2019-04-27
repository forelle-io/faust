defmodule Faust.Repo.Migrations.CreateFishesWaters do
  use Ecto.Migration

  alias Faust.Reservoir.Water
  alias Faust.Fishing.{Fish, FishWater}

  def change do
    fishing_fishes_waters_tn = Faust.fetch_table_name(%FishWater{})
    fishing_fishes_tn = Faust.fetch_table_name(%Fish{})
    reservoir_waters_tn = Faust.fetch_table_name(%Water{})

    create table(fishing_fishes_waters_tn, primary_key: false) do
      add :fish_id, references(fishing_fishes_tn, on_delete: :delete_all)
      add :water_id, references(reservoir_waters_tn, on_delete: :delete_all)
    end

    create index(fishing_fishes_waters_tn, [:fish_id])
    create index(fishing_fishes_waters_tn, [:water_id])
    create unique_index(fishing_fishes_waters_tn, [:fish_id, :water_id])
  end
end
