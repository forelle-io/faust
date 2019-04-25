defmodule Faust.Repo.Migrations.CreateFishesWaters do
  use Ecto.Migration

  def change do
    create table(:fishes_waters, primary_key: false) do
      add :fish_id, references(:fishes, on_delete: :delete_all)
      add :water_id, references(:waters, on_delete: :delete_all)
    end

    create index(:fishes_waters, [:fish_id])
    create index(:fishes_waters, [:water_id])
    create unique_index(:fishes_waters, [:fish_id, :water_id])
  end
end
