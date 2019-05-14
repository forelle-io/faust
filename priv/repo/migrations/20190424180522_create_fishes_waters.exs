defmodule Faust.Repo.Migrations.CreateFishesWaters do
  use Ecto.Migration

  alias Faust.Reservoir.Water
  alias Faust.Fishing.{Fish, FishWater}

  def change do
    fishing_fishes_waters_tn = Faust.fetch_table_name(%FishWater{})

    create table(fishing_fishes_waters_tn, primary_key: false) do
      add :fish_id, references(Faust.fetch_table_name(%Fish{}), on_delete: :delete_all),
        null: false

      add :water_id, references(Faust.fetch_table_name(%Water{}), on_delete: :delete_all),
        null: false
    end

    create index(fishing_fishes_waters_tn, [:fish_id])
    create index(fishing_fishes_waters_tn, [:water_id])
    create unique_index(fishing_fishes_waters_tn, [:fish_id, :water_id])
  end
end
