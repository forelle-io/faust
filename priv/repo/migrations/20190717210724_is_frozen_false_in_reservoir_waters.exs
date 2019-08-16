defmodule Faust.Repo.Migrations.IsFrozenFalseInReservoirWaters do
  use Ecto.Migration

  def change do
    alter table(:"reservoir.waters") do
      modify :is_frozen, :boolean, default: false
    end
  end
end
