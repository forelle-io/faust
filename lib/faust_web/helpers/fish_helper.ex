defmodule FaustWeb.FishHelper do
  @moduledoc false

  def fetch_fishes_params(resource_params, resource_fishes)
      when is_map(resource_params) and is_list(resource_fishes) do
    case resource_params do
      %{"fishes_ids" => []} ->
        %{resource_params | "fishes_ids" => []}

      %{"fishes_ids" => fishes} ->
        resource_fishes = Enum.map(resource_fishes, & &1.id)
        fishes = Enum.map(fishes, &String.to_integer/1)

        if Enum.sort(resource_fishes) == Enum.sort(fishes) do
          %{resource_params | "fishes_ids" => nil}
        else
          resource_params
        end

      _ ->
        case Enum.map(resource_fishes, & &1.id) do
          [] ->
            resource_params

          _ ->
            Map.put_new(resource_params, "fishes_ids", [])
        end
    end
  end
end
