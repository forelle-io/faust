defmodule Faust.Repo.Migrations.CreateTechniquesWaters do
  use Ecto.Migration

  alias Faust.Reservoir.Water
  alias Faust.Fishing.{Technique, TechniqueWater}

  def change do
    fishing_techniques_waters_tn = Faust.fetch_table_name(%TechniqueWater{})
    fishing_techniques_tn = Faust.fetch_table_name(%Technique{})
    reservoir_waters_tn = Faust.fetch_table_name(%Water{})

    create table(fishing_techniques_waters_tn, primary_key: false) do
      add :technique_id, references(fishing_techniques_tn, on_delete: :delete_all)
      add :water_id, references(reservoir_waters_tn, on_delete: :delete_all)
    end

    create index(fishing_techniques_waters_tn, [:technique_id])
    create index(fishing_techniques_waters_tn, [:water_id])
    create unique_index(fishing_techniques_waters_tn, [:technique_id, :water_id])
  end
end
