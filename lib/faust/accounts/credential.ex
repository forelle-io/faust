defmodule Faust.Accounts.Credential do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Faust.Accounts.{Chief, Organization, User}

  @regex_email ~r/\A[-\w.]+@([A-z0-9][-A-z0-9]+\.)+[A-z]{2,4}\z/
  @regex_unique ~r/\A[a-z0-9]+\z/

  schema "accounts.credentials" do
    field :unique, :string
    field :phone, :string
    field :email, :string
    field :password_hash, :string
    field :alchemic_avatar, :string

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
    |> cast(attrs, [:unique, :email, :password, :password_confirmation, :phone])
    |> validate_required([:unique, :email, :password, :password_confirmation])
    |> validate_format(:email, @regex_email)
    |> validate_format(:unique, @regex_unique)
    |> unique_constraint(:unique, name: :accounts_credentials_unique_index)
    |> unique_constraint(:email, name: :accounts_credentials_email_index)
    |> password_hash_pipeline()
    |> generate_alchemic_avatar()
  end

  def update_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation, :phone])
    |> validate_required([:email, :password_hash])
    |> validate_format(:email, @regex_email)
    |> validate_format(:unique, @regex_unique)
    |> validate_format(:phone, ~r/^\d{11}$/)
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

  defp generate_alchemic_avatar(%Changeset{} = changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{unique: unique}} ->
        file_path =
          unique
          |> String.upcase()
          |> AlchemicAvatar.generate(240)
          |> String.split("/")
          |> Enum.take(-3)
          |> Enum.join("/")

        Changeset.put_change(changeset, :alchemic_avatar, file_path)

      _ ->
        changeset
    end
  end
end
