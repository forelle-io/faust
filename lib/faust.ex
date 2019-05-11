defmodule Faust do
  @moduledoc """
  Faust keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def fetch_table_name(%_{} = struct) do
    struct.__struct__.__schema__(:source) |> String.to_atom()
  end
end
