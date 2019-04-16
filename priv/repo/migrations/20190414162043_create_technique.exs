defmodule Faust.Repo.Migrations.CreateTechniques do
  use Ecto.Migration

  def change do
    create table(:techniques) do
      add :name, :string
      add :description, :text
    end

    create unique_index(:techniques, :name)
  end
end
