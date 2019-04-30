defmodule Faust do
  @moduledoc """
  Faust keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def fetch_table_name(%_{} = struct) do
    struct
    |> fetch_table_name(%{atomize: false})
    |> String.to_atom()
  end

  def fetch_table_name(%_{} = struct, %{atomize: false}) do
    struct.__struct__.__schema__(:source)
  end
end
