defmodule Faust.Repo.Migrations.CreateWaters do
  use Ecto.Migration

  alias Faust.Accounts.User
  alias Faust.Reservoir.Water

  def change do
    reservoir_waters_tn = Faust.fetch_table_name(%Water{})

    create table(reservoir_waters_tn) do
      add :name, :string
      add :description, :text
      add :alchemic_avatar, :string
      add :is_frozen, :boolean
      add :latitude, :float
      add :longitude, :float

      add :user_id, references(Faust.fetch_table_name(%User{}), on_delete: :delete_all),
        null: false

      timestamps()
    end

    create index(reservoir_waters_tn, [:user_id])
  end
end
