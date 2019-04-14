defmodule Faust.Fishing do
  @moduledoc """
  The Fishing context.
  """

  import Ecto.Query, warn: false

  alias Faust.Fishing.Fish
  alias Faust.Repo

  # Fish structure -------------------------------------------------------------

  alias Faust.Fishing.Fish

  def list_fishes do
    Repo.all(Fish)
  end

  def list_fishes(ids) when is_list(ids) do
    ids
    |> Fish.list_fishes_query()
    |> Repo.all()
  end

  def get_fish!(id), do: Repo.get!(Fish, id)

  def create_fish(attrs \\ %{}) do
    %Fish{}
    |> Fish.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_fish(%Fish{} = fish, attrs) do
    fish
    |> Fish.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_fish(%Fish{} = fish) do
    Repo.delete(fish)
  end

  def change_fish(%Fish{} = fish) do
    Fish.update_changeset(fish, %{})
  end
end
