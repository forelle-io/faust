defmodule Faust.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  # Credential structure -------------------------------------------------------

  alias Faust.Accounts.Credential

  def list_credentials do
    Repo.all(Credential)
  end

  def get_credential!(id), do: Repo.get!(Credential, id)

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential) do
    Credential.update_changeset(credential, %{})
  end

  def session_credential(%Credential{} = credential) do
    Credential.session_changeset(credential, %{})
  end

  # User structure -------------------------------------------------------

  alias Faust.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def list_users(preloads) when is_list(preloads) do
    User
    |> Repo.all()
    |> Repo.preload(preloads)
  end

  def list_users_by_name_surname_like(expression)
      when is_bitstring(expression) do
    expression
    |> User.list_users_by_name_surname_like_query()
    |> Repo.all()
    |> Repo.preload(:credential)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by(params) when is_map(params) do
    Repo.get_by(User, params)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  # Organization structure -------------------------------------------------------

  alias Faust.Accounts.Organization

  def list_organizations do
    Repo.all(Organization)
  end

  def get_organization!(id), do: Repo.get!(Organization, id)

  def get_organization(id), do: Repo.get(Organization, id)

  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  def change_organization(%Organization{} = organization) do
    Organization.update_changeset(organization, %{})
  end

  # Chief structure -------------------------------------------------------

  alias Faust.Accounts.Chief

  def list_chiefs do
    Repo.all(Chief)
  end

  def get_chief!(id), do: Repo.get!(Chief, id)

  def get_chief(id), do: Repo.get(Chief, id)

  def create_chief(attrs \\ %{}) do
    %Chief{}
    |> Chief.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_chief(%Chief{} = chief, attrs) do
    chief
    |> Chief.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_chief(%Chief{} = chief) do
    Repo.delete(chief)
  end

  def change_chief(%Chief{} = chief) do
    Chief.update_changeset(chief, %{})
  end
end
