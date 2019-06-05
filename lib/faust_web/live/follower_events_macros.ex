defmodule FaustWeb.FollowerEventsMacros do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias FaustWeb.Snoop.FollowerService

      def handle_event(
            "follower_create",
            value,
            %{assigns: %{current_user: current_user, list_followee_ids: list_followee_ids}} =
              socket
          ) do
        case FollowerService.follower_create(
               current_user,
               list_followee_ids,
               value |> String.to_integer()
             ) do
          {:ok, list_followee_ids} ->
            {:noreply, assign(socket, list_followee_ids: list_followee_ids)}

          {:error, _reason} ->
            {:noreply, socket}
        end
      end

      def handle_event(
            "follower_delete",
            value,
            %{assigns: %{current_user: current_user, list_followee_ids: list_followee_ids}} =
              socket
          ) do
        case FollowerService.follower_delete(
               current_user,
               list_followee_ids,
               value |> String.to_integer()
             ) do
          {:ok, list_followee_ids} ->
            {:noreply, assign(socket, list_followee_ids: list_followee_ids)}

          {:error, _reason} ->
            {:noreply, socket}
        end
      end
    end
  end
end
