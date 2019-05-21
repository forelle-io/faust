defmodule FaustWeb.Policies.Accounts.UserPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories, only: [insert: 1]

  alias FaustWeb.Accounts.UserPolicy

  setup do
    {:ok, current_user: insert(:accounts_user)}
  end

  describe "edit" do
    test "разрешение, когда ресурсом является текущая структура user", %{
      current_user: current_user
    } do
      assert UserPolicy.authorize(:edit, current_user, current_user)
    end

    test "запрет, когда ресурсом является другая структура user", %{current_user: current_user} do
      user = insert(:accounts_user)

      refute UserPolicy.authorize(:edit, current_user, user)
    end

    test "разрешение, когда ресурсом является id текущей структуры user", %{
      current_user: current_user
    } do
      assert UserPolicy.authorize(:edit, current_user, current_user.id)
    end

    test "запрет, когда ресурсом является id другой структуры user", %{current_user: current_user} do
      refute UserPolicy.authorize(:edit, current_user, current_user.id + 1)
    end
  end

  describe "update" do
    test "разрешение, когда ресурсом является текущая структура user", %{
      current_user: current_user
    } do
      assert UserPolicy.authorize(:update, current_user, current_user)
    end

    test "запрет, когда ресурсом является другая структура user", %{current_user: current_user} do
      user = insert(:accounts_user)

      refute UserPolicy.authorize(:update, current_user, user)
    end

    test "разрешение, когда ресурсом является id текущей структуры user", %{
      current_user: current_user
    } do
      assert UserPolicy.authorize(:update, current_user, current_user.id)
    end

    test "запрет, когда ресурсом является id другой структуры user", %{current_user: current_user} do
      refute UserPolicy.authorize(:update, current_user, current_user.id + 1)
    end
  end

  describe "delete" do
    test "разрешение, когда ресурсом является текущая структура user", %{
      current_user: current_user
    } do
      assert UserPolicy.authorize(:delete, current_user, current_user)
    end

    test "запрет, когда ресурсом является другая структура user", %{current_user: current_user} do
      user = insert(:accounts_user)

      refute UserPolicy.authorize(:delete, current_user, user)
    end

    test "разрешение, когда ресурсом является id текущей структуры user", %{
      current_user: current_user
    } do
      assert UserPolicy.authorize(:delete, current_user, current_user.id)
    end

    test "запрет, когда ресурсом является id другой структуры user", %{current_user: current_user} do
      refute UserPolicy.authorize(:delete, current_user, current_user.id + 1)
    end
  end
end
