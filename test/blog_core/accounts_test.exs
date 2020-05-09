defmodule BlogCore.AccountsTest do
  use BlogCore.DataCase
  import BlogCore.Factory

  alias BlogCore.Accounts

  describe "users" do
    alias BlogCore.Accounts.User

    @invalid_attrs %{bio: nil, email: "invalidemail", name: "k", username: "bilbo$"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(build(:user))
        |> Accounts.create_user()

      user
    end

    test "create_user/1 with valid data creates a user" do
      expected = build(:user)
      assert {:ok, %User{} = actual} = Accounts.create_user(expected)
      assert actual.bio == expected.bio
      assert actual.email == expected.email
      assert actual.name == expected.name
      assert actual.username == expected.username
      assert actual.password_hash != expected.password
      assert Map.get(actual, :password) == nil
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
      update_attrs = build(:user)
      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.bio == update_attrs.bio
      assert user.email == update_attrs.email
      assert user.name == update_attrs.name
      assert user.username == update_attrs.username
      assert user.password_hash != update_attrs.password
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

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(build(:author))
        |> Accounts.create_author()

      author
    end

    test "create_author/1 with valid data creates a author" do
      expected = build(:author)
      assert {:ok, %Author{} = actual} = Accounts.create_author(expected)
      assert expected.user.username == actual.user.username
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_author(@invalid_attrs)
    end

    test "get_author/1 returns {:ok, author} when there is a match for id" do
      author = author_fixture()
      assert Accounts.get_author(author.id) == {:ok, author}
    end

    test "get_author/1 returns {:error, :not_found} when there is no match for id" do
      assert {:error, :not_found} == Accounts.get_author("9438d85b-b3a0-427f-9301-b3fbcfcb17e7")
    end

    test "get_author_from_username/1 returns {:ok, author} when match exists" do
      author = author_fixture()
      _id = author.id
      assert {:ok, %Author{id: _id}} = Accounts.get_author_from_username(author.user.username) 
    end

    test "get_author_from_username/1 returns {:error, :not_found} when match not found" do
      assert {:error, :not_found} = Accounts.get_author_from_username("invalid_username")
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      attrs = update_attrs(author)

      assert {:ok, %Author{} = author} = Accounts.update_author(author, attrs)
      assert author.user.id == attrs.user.id
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      attrs = invalid_attrs(author)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_author(author, attrs)
      assert Accounts.get_author(author.id) == {:ok, author}
    end

    defp invalid_attrs(author) do
      user = author
      |> Map.get(:user)
      |> Map.from_struct()
      |> Map.merge(%{username: "x"})

      %{user: user}
    end

    defp update_attrs(author) do
      user = author
      |> Map.get(:user)
      |> Map.from_struct()
      |> Map.merge(%{username: build(:user).username})

      %{user: user}
    end
  end
end
