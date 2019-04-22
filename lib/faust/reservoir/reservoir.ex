defmodule Faust.Reservoir do
  @moduledoc """
  The Reservoir context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  alias Faust.Reservoir.Water

  def list_waters(user_id)
      when is_bitstring(user_id) or is_integer(user_id) do
    user_id
    |> Water.list_water_query()
    |> Repo.all()
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
