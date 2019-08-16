defmodule Faust.Repo.Migrations.CreateUniqueCompositeIndexToSnoopFollowers do
  use Ecto.Migration

  def change do
    create unique_index(:"snoop.followers", [:user_id, :follower_id])
  end
end
