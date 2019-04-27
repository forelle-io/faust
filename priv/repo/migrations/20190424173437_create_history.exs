defmodule Faust.Repo.Migrations.CreateHistory do
  use Ecto.Migration

  alias Faust.Reservoir.{History, Water}

  def change do
    reservoir_histories_tn = Faust.fetch_table_name(%History{})

    create table(reservoir_histories_tn) do
      add :type, :string
      add :description, :text
      add :water_id, references(Faust.fetch_table_name(%Water{}), on_delete: :delete_all)

      timestamps()
    end

    create unique_index(reservoir_histories_tn, :id)
  end
end
