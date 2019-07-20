defmodule FaustWeb.FishView do
  use FaustWeb, :view

  alias Faust.{Fishing, VirtualTableGenServer}

  def fishes_for_multiple_select do
    {_, list_fishes} = :ets.lookup(:hot_tables, "fishing.fishes") |> List.first()
    list_fishes
  end

  def fishes_tags(_conn, []), do: ""

  def fishes_tags(conn, fishes) when is_list(fishes) do
    Enum.reduce(fishes, "", fn fish, acc ->
      link =
        fish.name
        |> link(to: Routes.user_path(conn, :index), class: "topic")
        |> Phoenix.HTML.safe_to_string()

      acc <> link
    end)
  end
end
