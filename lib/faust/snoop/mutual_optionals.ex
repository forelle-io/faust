defmodule Faust.Snoop.MutualOptionals do
  @moduledoc false

  defmacro __using__(opts) do
    module_name = Keyword.get(opts, :module_name)

    quote do
      use Ecto.Schema

      import Ecto.{Changeset, Query}

      # SQL запросы ------------------------------------------------------------

      def list_followee_ids_query(user_id) do
        from f in unquote(module_name),
          select: f.follower_id,
          where: f.user_id == ^user_id
      end

      def list_follower_ids_query(user_id) do
        user_id
        |> followers_query()
        |> select([f], f.follower_id)
      end

      def followers_query(user_id) do
        from f in unquote(module_name),
          where: f.follower_id == ^user_id
      end
    end
  end
end
