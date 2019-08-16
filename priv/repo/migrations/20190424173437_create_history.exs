defmodule Faust.Repo.Migrations.CreateHistory do
  use Ecto.Migration

  def change do
    create table(:"reservoir.histories") do
      add :type, :string
      add :description, :text
      add :water_id, references(:"reservoir.waters", on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:"reservoir.histories", :id)
  end
end
