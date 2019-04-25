defmodule Faust.Reservoir do
  @moduledoc """
  The Reservoir context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  alias Faust.Reservoir.Water

  def list_waters(preloads) when is_list(preloads) do
    Water
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_waters(user_id, preloads)
      when (is_bitstring(user_id) or is_integer(user_id)) and is_list(preloads) do
    user_id
    |> Water.list_water_query()
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_waters do
    Repo.all(Water)
  end

  def get_water!(id), do: Repo.get!(Water, id)

  def create_water(attrs \\ %{}) do
    %Water{}
    |> Water.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_water(%Water{} = water, attrs) do
    water
    |> Water.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_water(%Water{} = water) do
    Repo.delete(water)
  end

  def change_water(%Water{} = water) do
    Water.update_changeset(water, %{})
  end
end
