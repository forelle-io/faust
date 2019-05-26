defmodule Faust.Accounts.CredentialTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.AccountFixtures, only: [credential_attrs: 1]

  alias Faust.Accounts
  alias Faust.Accounts.Credential
  alias Faust.Crypto

  describe "list_credentials/0" do
    test "когда записи credentials отсутствуют" do
      assert Accounts.list_credentials() |> Enum.empty?()
    end

    test "когда записи credentials присутствуют в количестве 5" do
      insert_list(5, :accounts_credential)

      assert Accounts.list_credentials() |> length() == 5
    end
  end

  describe "get_credential!/1" do
    test "когда запись credential отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_credential!(1)
      end
    end

    test "когда запись credential присутствует" do
      %Credential{id: id} = insert(:accounts_credential)
      credential = Accounts.get_credential!(id)

      assert credential.id == id
    end
  end

  describe "create_credential/1" do
    test "когда данные не валидны по user классификации" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :user
        |> credential_attrs()
        |> Map.merge(%{"unique" => nil, "email" => nil, "password" => nil})
        |> Accounts.create_credential()

      refute changeset.valid?

      assert errors[:password_confirmation] ==
               {"does not match confirmation", [validation: :confirmation]}

      errors
      |> Enum.filter(fn {k, _v} -> Enum.member?([:unique, :email, :password], k) end)
      |> Enum.each(fn {_k, v} -> assert v == {"can't be blank", [validation: :required]} end)
    end

    test "когда создание credential по user классификации происходит с данными уже существующей записи" do
      credential = insert(:accounts_credential)

      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :user
        |> credential_attrs()
        |> Map.merge(%{"email" => credential.email})
        |> Accounts.create_credential()

      refute changeset.valid?

      assert errors[:email] ==
               {"has already been taken",
                [constraint: :unique, constraint_name: "accounts_credentials_email_index"]}
    end

    test "когда данные валидны по user классификации" do
      assert {:ok, %Credential{}} =
               :user
               |> credential_attrs()
               |> Accounts.create_credential()
    end
  end

  describe "update_credential/2" do
    test "когда данные не валидны по user классификации" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :accounts_credential
        |> insert()
        |> Accounts.update_credential(%{
          "email" => nil,
          "password" => "password",
          "password_confirmation" => "password_confirmation"
        })

      refute changeset.valid?

      assert errors[:password_confirmation] ==
               {"does not match confirmation", [validation: :confirmation]}

      assert errors[:email] == {"can't be blank", [validation: :required]}
    end

    test "когда обновление credential по user классификации происходит с данными уже существующей записи" do
      credential = insert(:accounts_credential)

      assert {:error, %Ecto.Changeset{errors: errors} = changeset} =
               :accounts_credential
               |> insert()
               |> Accounts.update_credential(%{"email" => credential.email})

      refute changeset.valid?

      assert errors[:email] ==
               {"has already been taken",
                [constraint: :unique, constraint_name: "accounts_credentials_email_index"]}
    end

    test "когда данные валидны по user классификации" do
      new_email = Crypto.generate_unique_alphabet_string(8) <> "@gmail.com"

      {:ok, credential} =
        :accounts_credential
        |> insert()
        |> Accounts.update_credential(%{
          "email" => new_email,
          "password" => "new_password",
          "password_confirmation" => "new_password"
        })

      assert credential.email == new_email
      assert Bcrypt.verify_pass("new_password", credential.password_hash)
    end
  end

  describe "delete_credential/1" do
    test "когда запись credential присутствует" do
      credential = insert(:accounts_credential)

      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_credential!(credential.id)
      end
    end
  end

  describe "change_credential/1" do
    test "когда запись credential присутствует" do
      assert %Ecto.Changeset{} =
               :accounts_credential
               |> insert()
               |> Accounts.change_credential()
    end

    test "когда запись credential отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} =
               %Credential{} |> Accounts.change_credential()

      assert errors[:email] == {"can't be blank", [validation: :required]}
      assert errors[:password_hash] == {"can't be blank", [validation: :required]}
    end
  end

  describe "session_credential/1" do
    test "когда запись credential присутствует" do
      assert %Ecto.Changeset{} =
               :accounts_credential
               |> insert()
               |> Accounts.session_credential()
    end

    test "когда запись credential отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} =
               Accounts.session_credential(%Credential{})

      Enum.each(errors, fn {_k, v} -> assert v == {"can't be blank", [validation: :required]} end)
    end
  end
end
