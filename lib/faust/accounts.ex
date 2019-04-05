defmodule Faust.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Faust.Repo

  # Credential structure -------------------------------------------------------

  alias Faust.Accounts.Credential

  @doc """
  Returns the list of credentials.

  ## Examples

      iex> list_credentials()
      [%Credential{}, ...]

  """
  def list_credentials do
    Repo.all(Credential)
  end

  @doc """
  Gets a single credential.

  Raises `Ecto.NoResultsError` if the Credential does not exist.

  ## Examples

      iex> get_credential!(123)
      %Credential{}

      iex> get_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credential!(id), do: Repo.get!(Credential, id)

  @doc """
  Creates a credential.

  ## Examples

      iex> create_credential(%{field: value})
      {:ok, %Credential{}}

      iex> create_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credential.

  ## Examples

      iex> update_credential(credential, %{field: new_value})
      {:ok, %Credential{}}

      iex> update_credential(credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Credential.

  ## Examples

      iex> delete_credential(credential)
      {:ok, %Credential{}}

      iex> delete_credential(credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credential changes.

  ## Examples

      iex> change_credential(credential)
      %Ecto.Changeset{source: %Credential{}}

  """
  def change_credential(%Credential{} = credential) do
    Credential.update_changeset(credential, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credential session changes.

  ## Examples

      iex> change_credential(credential)
      %Ecto.Changeset{source: %Credential{}}

  """
  def session_credential(%Credential{} = credential) do
    Credential.session_changeset(credential, %{})
  end

  # User structure -------------------------------------------------------

  alias Faust.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  Returns nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by params.

  Returns nil if the User by params does not exist.

  ## Examples

      iex> get_user_by(%{key: value})
      %User{}

      iex> get_user_by(%{key: value})
      nil

  """
  def get_user_by(params) when is_map(params) do
    Repo.get_by(User, params)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.update_changeset(user, %{})
  end

  # Organization structure -------------------------------------------------------

  alias Faust.Accounts.Organization

  @doc """
  Returns the list of organization.

  ## Examples

      iex> list_organization()
      [%Organization{}, ...]

  """
  def list_organization do
    Repo.all(Organization)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

      iex> get_organization!(456)
      ** (Ecto.NoResultsError)

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  @doc """
  Gets a single organization.

  Returns nil if the Organization does not exist.

  ## Examples

      iex> get_organization(123)
      %Organization{}

      iex> get_organization(456)
      nil

  """
  def get_organization(id), do: Repo.get(Organization, id)

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_organization(attrs \\ %{}) do
    %Organization{}
    |> Organization.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, %Ecto.Changeset{}}

  """
  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Ecto.Changeset{source: %Organization{}}

  """
  def change_organization(%Organization{} = organization) do
    Organization.update_changeset(organization, %{})
  end

  # Chief structure -------------------------------------------------------

  alias Faust.Accounts.Chief

  @doc """
  Returns the list of chief.

  ## Examples

      iex> list_chief()
      [%Chief{}, ...]

  """
  def list_chief do
    Repo.all(Chief)
  end

  @doc """
  Gets a single chief.

  Raises `Ecto.NoResultsError` if the Chief does not exist.

  ## Examples

      iex> get_chief!(123)
      %Chief{}

      iex> get_chief!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chief!(id), do: Repo.get!(Chief, id)

  @doc """
  Gets a single chief.

  Returns nil if the Chief does not exist.

  ## Examples

      iex> get_chief(123)
      %Chief{}

      iex> get_chief(456)
      nil

  """
  def get_chief(id), do: Repo.get(Chief, id)

  @doc """
  Creates a chief.

  ## Examples

      iex> create_chief(%{field: value})
      {:ok, %Chief{}}

      iex> create_chief(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chief(attrs \\ %{}) do
    %Chief{}
    |> Chief.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chief.

  ## Examples

      iex> update_chief(chief, %{field: new_value})
      {:ok, %Chief{}}

      iex> update_chief(chief, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chief(%Chief{} = chief, attrs) do
    chief
    |> Chief.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chief.

  ## Examples

      iex> delete_chief(chief)
      {:ok, %Chief{}}

      iex> delete_chief(chief)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chief(%Chief{} = chief) do
    Repo.delete(chief)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chief changes.

  ## Examples

      iex> change_chief(chief)
      %Ecto.Changeset{source: %Chief{}}

  """
  def change_chief(%Chief{} = chief) do
    Chief.update_changeset(chief, %{})
  end
end
