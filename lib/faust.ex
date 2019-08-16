defmodule Faust do
  @moduledoc """
  Faust keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def media_location, do: "#{System.user_home()}/media"
end
