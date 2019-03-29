defmodule Faust.Accounts.Credential do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Ecto.Changeset

  schema "credentials" do
    field :unique, :string
    field :phone, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  # Changesets fields ----------------------------------------------------------

  def create_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:unique, :email, :password, :password_confirmation])
    |> validate_required([:unique, :email, :password, :password_confirmation])
    |> password_hash_pipeline()
  end

  def update_changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> password_hash_pipeline()
  end

  # Private functions ----------------------------------------------------------

  defp password_hash_pipeline(%Changeset{} = changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 16)
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
