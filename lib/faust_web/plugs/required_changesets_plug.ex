defmodule FaustWeb.RequiredChangesetsPlug do
  @moduledoc false

  import Plug.Conn

  alias Faust.Reservoir
  alias Faust.Reservoir.Water

  def init(_default), do: nil

  def call(%Plug.Conn{} = conn, _default) do
    changeset_water = Reservoir.change_water(%Water{})
    assign(conn, :changeset_water, changeset_water)
  end
end
