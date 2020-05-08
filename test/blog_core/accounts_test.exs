defmodule BlogCore.AccountsTest do
  use BlogCore.DataCase

  alias BlogCore.Accounts

  describe "users" do
    alias BlogCore.Accounts.User

    @valid_attrs %{bio: nil, email: "email@example.com", name: "bilbo", username: "dragonwhisperer", password: "Sm4ug$$$"}
    @update_attrs %{bio: "some bio", email: "update@example.com", name: "Bilbo", username: "trollwhisperer", password: "Tr0ll$$$"}
    @invalid_attrs %{bio: nil, email: "invalidemail", name: "k", username: "bilbo$"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()
      user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.bio == nil
      assert user.email == "email@example.com"
      assert user.name == "bilbo"
      assert user.username == "dragonwhisperer"
      assert user.password_hash != "Sm4ug$$$"
      assert Map.get(user, :password) == nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "get_user/1 returns {:ok, user} when there is a match for id" do
      user = user_fixture()
      assert Accounts.get_user(user.id) == {:ok, user}
    end

    test "get_user/1 returns {:error, :not_found} when there is no match for id" do
      assert {:error, :not_found} == Accounts.get_user("9438d85b-b3a0-427f-9301-b3fbcfcb17e7")
    end

    test "get_user_from_username/1 returns {:ok, user} when match exists" do
      user = user_fixture()
      assert Accounts.get_user_from_username(user.username) == {:ok, user}
    end

    test "get_user_from_username/1 returns {:error, :not_found} when match not found" do
      assert {:error, :not_found} = Accounts.get_user_from_username("invalid_username")
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.bio == "some bio"
      assert user.email == "update@example.com"
      assert user.name == "Bilbo"
      assert user.username == "trollwhisperer"
      assert user.password_hash != "Tr0ll$$$"
      assert Map.get(user, :password) == nil
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert Accounts.get_user(user.id) == {:ok, user}
    end
  end

  describe "authors" do
    alias BlogCore.Accounts.Author
  end
end
