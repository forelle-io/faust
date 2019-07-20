defmodule Faust.HotTablesTablesGenServer do
  @moduledoc false

  use GenServer

  alias Faust.Fishing

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(_default) do
    {:ok, %{}, {:continue, "create_hot_tables"}}
  end

  def handle_continue("create_hot_tables", state) do
    :ets.new(:hot_tables, [:set, :protected, :named_table])

    Enum.each(["fishes", "techniques"], fn item ->
      :ets.insert(
        :hot_tables,
        {"fishing.#{item}",
         Fishing |> apply(String.to_atom("list_#{item}"), []) |> Enum.map(&{&1.name, &1.id})}
      )
    end)

    {:noreply, state}
  end

  def handle_info(_message, state), do: {:noreply, state}
end
