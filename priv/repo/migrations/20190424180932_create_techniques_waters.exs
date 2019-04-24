defmodule Faust.Repo.Migrations.CreateTechniquesWaters do
  use Ecto.Migration

  def change do
    create table(:techniques_waters, primary_key: false) do
      add :technique_id, references(:techniques, on_delete: :delete_all)
      add :water_id, references(:techniques, on_delete: :delete_all)
    end

    create index(:techniques_waters, [:technique_id])
    create index(:techniques_waters, [:water_id])
    create unique_index(:techniques_waters, [:technique_id, :water_id])
  end
end
