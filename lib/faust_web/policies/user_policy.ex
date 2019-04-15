defmodule FaustWeb.UserPolicy do
  @moduledoc false
  @behaviour Bodyguard.Policy

  alias Faust.Accounts.User

  def authorize(action, %User{id: id}, %User{id: id})
      when action in [:edit, :update, :delete] do
    true
  end

  def authorize(action, %User{id: id}, id)
      when action in [:edit, :update, :delete] do
    true
  end

  def authorize(_, _, _), do: false
end
