defmodule Faust.Repo.Migrations.CreateTechniquesWaters do
  use Ecto.Migration

  def change do
    create table(:"fishing.techniques_waters", primary_key: false) do
      add :technique_id, references(:"fishing.techniques", on_delete: :delete_all), null: false

      add :water_id, references(:"reservoir.waters", on_delete: :delete_all), null: false
    end

    create index(:"fishing.techniques_waters", [:technique_id])
    create index(:"fishing.techniques_waters", [:water_id])
    create unique_index(:"fishing.techniques_waters", [:technique_id, :water_id])
  end
end
