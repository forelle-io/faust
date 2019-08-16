defmodule Faust.Repo.Migrations.CreateWaters do
  use Ecto.Migration

  def change do
    create table(:"reservoir.waters") do
      add :name, :string
      add :description, :text
      add :alchemic_avatar, :string
      add :is_frozen, :boolean
      add :latitude, :float
      add :longitude, :float
      add :type, :string
      add :bottom_type, :string
      add :color, :string
      add :environment, :string

      add :user_id, references(:"accounts.users", on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:"reservoir.waters", [:user_id])
  end
end
