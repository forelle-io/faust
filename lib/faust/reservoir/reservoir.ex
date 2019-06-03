defmodule Faust.Reservoir do
  @moduledoc """
  The Reservoir context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo
  alias Faust.Reservoir.{History, Water}

  # Waters scructure -----------------------------------------------------------------

  def list_waters do
    Repo.all(Water)
  end

  def list_waters(preloads) when is_list(preloads) do
    Water
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_waters(user_id, preloads)
      when is_integer(user_id) and is_list(preloads) do
    user_id
    |> Water.list_water_query()
    |> Repo.all()
    |> Repo.preload(preloads)
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

  # History scructure -----------------------------------------------------------------

  def list_histories do
    Repo.all(History)
  end

  def list_histories(water_id)
      when is_bitstring(water_id) or is_integer(water_id) do
    water_id
    |> History.list_history_query()
    |> Repo.all()
  end

  def get_history!(id), do: Repo.get!(History, id)

  def create_history(attrs \\ %{}) do
    %History{}
    |> History.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_history(%History{} = history, attrs) do
    history
    |> History.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_history(%History{} = history) do
    Repo.delete(history)
  end

  def change_history(%History{} = history) do
    History.update_changeset(history, %{})
  end
end
