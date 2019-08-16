defmodule Faust.Repo.Migrations.ChangeSnoopSchemas do
  use Ecto.Migration

  def change do
    rename table(:"snoop.followers"), to: table(:"snoop.follower_users")

    create table(:"snoop.follower_waters", primary_key: false) do
      add :user_id, references(:"accounts.users"),
        on_delete: :delete_all,
        null: false,
        primary_key: true

      add :follower_id, references(:"reservoir.waters"),
        on_delete: :delete_all,
        null: false,
        primary_key: true
    end

    create index(:"snoop.follower_waters", [:user_id])
    create index(:"snoop.follower_waters", [:follower_id])

    create unique_index(:"snoop.follower_waters", [:user_id, :follower_id])
  end
end
