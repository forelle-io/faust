defmodule FaustWeb.TechniqueHelper do
  @moduledoc false

  def fetch_techniques_params(resource_params, resource_techniques)
      when is_map(resource_params) and is_list(resource_techniques) do
    case resource_params do
      %{"techniques_ids" => []} ->
        %{resource_params | "techniques_ids" => []}

      %{"techniques_ids" => techniques} ->
        resource_techniques = Enum.map(resource_techniques, & &1.id)
        techniques = Enum.map(techniques, &String.to_integer/1)

        if Enum.sort(resource_techniques) == Enum.sort(techniques) do
          %{resource_params | "techniques_ids" => nil}
        else
          resource_params
        end

      _ ->
        case Enum.map(resource_techniques, & &1.id) do
          [] ->
            resource_params

          _ ->
            Map.put_new(resource_params, "techniques_ids", [])
        end
    end
  end
end
