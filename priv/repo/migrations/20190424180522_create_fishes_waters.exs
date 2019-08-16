defmodule Faust.Repo.Migrations.CreateFishesWaters do
  use Ecto.Migration

  def change do
    create table(:"fishing.fishes_waters", primary_key: false) do
      add :fish_id, references(:"fishing.fishes", on_delete: :delete_all), null: false

      add :water_id, references(:"reservoir.waters", on_delete: :delete_all), null: false
    end

    create index(:"fishing.fishes_waters", [:fish_id])
    create index(:"fishing.fishes_waters", [:water_id])
    create unique_index(:"fishing.fishes_waters", [:fish_id, :water_id])
  end
end
