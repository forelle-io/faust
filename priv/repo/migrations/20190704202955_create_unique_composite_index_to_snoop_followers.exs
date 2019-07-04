defmodule Faust.Repo.Migrations.CreateUniqueCompositeIndexToSnoopFollowers do
  use Ecto.Migration

  alias Faust.Snoop.Follower

  def change do
    create unique_index(Faust.fetch_table_name(%Follower{}), [:user_id, :follower_id])
  end
end
