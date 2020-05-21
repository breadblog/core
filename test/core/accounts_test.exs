defmodule Core.AccountsTest do
  use Core.DataCase

  alias Core.Accounts

  describe "users" do
    alias Core.Accounts.User

    @valid_attrs %{name: "some name", password: "some password A1!", username: "someusername"}
    @update_attrs %{
      name: "some updated name",
      password: "some updated password A1!",
      username: "updatedusername"
    }
    @invalid_attrs %{name: nil, password: "badpassword", username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      users = Accounts.list_users()
      assert Enum.member?(users, user)
      assert Enum.all?(users, &(&1 = %User{}))
      assert length(users) == 3
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == {:ok, user}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == @valid_attrs.name
      assert user.password != @valid_attrs.password
      assert user.password != nil
      assert user.username == @valid_attrs.username
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == @update_attrs.name
      assert user.password != @valid_attrs.password
      assert user.password != @update_attrs.password
      assert user.password != nil
      assert user.username == @update_attrs.username
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert {:ok, user} == Accounts.get_user(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} == Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
