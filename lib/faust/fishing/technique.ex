defmodule Faust.Fishing.Technique do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias Faust.Accounts.User
  alias Faust.Fishing.Technique

  schema "techniques" do
    field :name, :string, default: false
    field :description, :string, default: false

    many_to_many :users, User, join_through: "techniques_users", on_replace: :delete
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(technique, attrs) do
    technique
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end

  def update_changeset(technique, attrs) do
    technique
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end

  # SQL запросы ----------------------------------------------------------------

  def list_technique_query(ids) do
    from f in Technique,
      where: f.id in ^ids
  end
end
