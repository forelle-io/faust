defmodule Faust.Accounts.UserTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.AccountFixtures, only: [user_attrs: 0]

  alias Faust.Accounts
  alias Faust.Accounts.{Credential, User}

  describe "list_users/0" do
    test "когда записи users отсутствуют" do
      assert Accounts.list_users() |> Enum.empty?()
    end

    test "когда записи users присутствуют в количестве 5" do
      insert_list(5, :accounts_user)

      assert Accounts.list_users() |> length() == 5
    end
  end

  describe "list_users/1" do
    test "когда записи users присутствуют в количестве 5 с пустой предзагрузкой" do
      insert_list(5, :accounts_user)
      assert Accounts.list_users([]) |> length() == 5
    end

    test "когда записи users присутствуют в количестве 5 с предзагрузкой credential" do
      insert_list(5, :accounts_user)
      list_users = Accounts.list_users([:credential])

      assert length(list_users) == 5

      assert Enum.all?(list_users, fn user ->
               case user do
                 %User{credential: %Credential{}} ->
                   true

                 _ ->
                   false
               end
             end)
    end
  end

  describe "get_user!/1" do
    test "когда запись user отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(1)
      end
    end

    test "когда запись user присутствует" do
      %User{id: id} = insert(:accounts_user)
      user = Accounts.get_user!(id)

      assert user.id == id
    end
  end

  describe "get_user/1" do
    test "когда запись user отсутствует" do
      refute Accounts.get_user(1)
    end

    test "когда запись user присутствует" do
      %User{id: id} = insert(:accounts_user)
      user = Accounts.get_user(id)

      assert user.id == id
    end
  end

  describe "get_user_by/1" do
    test "когда параметры пустые" do
      refute Accounts.get_user_by(%{})
    end

    test "когда параметрах указаны имя и фамилия" do
      %User{id: id, name: name, surname: surname} = insert(:accounts_user)
      user = Accounts.get_user_by(%{name: name, surname: surname})

      assert user.id == id
      assert user.name == name
      assert user.surname == surname
    end
  end

  describe "create_user/1" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        user_attrs()
        |> Map.merge(%{"name" => nil, "surname" => nil})
        |> Accounts.create_user()

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:surname] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      assert {:ok, %User{}} = user_attrs() |> Accounts.create_user()
    end
  end

  describe "update_user/2" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :accounts_user
        |> insert()
        |> Accounts.update_user(%{"name" => nil, "surname" => nil})

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:surname] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      {:ok, user} =
        :accounts_user
        |> insert()
        |> Accounts.update_user(%{"name" => "Карл", "surname" => "Фридрих"})

      assert user.name == "Карл"
      assert user.surname == "Фридрих"
    end
  end

  describe "delete_user/1" do
    test "когда запись user присутствует" do
      user = insert(:accounts_user)

      assert {:ok, %User{}} = Accounts.delete_user(user)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(user.id)
      end
    end
  end

  describe "change_user/1" do
    test "когда запись user присутствует" do
      assert %Ecto.Changeset{} =
               :accounts_user
               |> insert()
               |> Accounts.change_user()
    end

    test "когда запись user отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} = Accounts.change_user(%User{})

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:surname] == {"can't be blank", [validation: :required]}
    end
  end
end
