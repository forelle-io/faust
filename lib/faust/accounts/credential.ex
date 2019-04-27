defmodule Faust.Accounts.Credential do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Faust.Accounts.{Chief, Organization, User}

  schema "accounts.credentials" do
    field :unique, :string
    field :phone, :string
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()

    has_one :user, User
    has_one :organization, Organization
    has_one :chief, Chief
  end

  # Changesets -----------------------------------------------------------------

  def create_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:unique, :email, :password, :password_confirmation])
    |> validate_required([:unique, :email, :password, :password_confirmation])
    |> unique_constraint(:unique, name: :accounts_credentials_unique_index)
    |> unique_constraint(:email, name: :accounts_credentials_email_index)
    |> password_hash_pipeline()
  end

  def update_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password_hash])
    |> unique_constraint(:email, name: :accounts_credentials_email_index)
    |> password_hash_pipeline()
  end

  def session_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:unique, :password])
    |> validate_required([:unique, :password])
    |> validate_length(:password, min: 8)
  end

  # Приватные функции ----------------------------------------------------------

  defp password_hash_pipeline(%Changeset{} = changeset) do
    changeset
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{} = changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{password: password}} ->
        password_hash = Bcrypt.hash_pwd_salt(password)
        Changeset.put_change(changeset, :password_hash, password_hash)

      _ ->
        changeset
    end
  end
end
