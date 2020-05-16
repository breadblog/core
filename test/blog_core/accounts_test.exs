defmodule BlogCore.AccountsTest do
  use BlogCore.DataCase, async: true
  import BlogCore.Factory

  alias BlogCore.Accounts

  describe "users" do
    alias BlogCore.Accounts.User

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        build(:user, attrs)
        |> Accounts.create_user()

      user
    end

    test "create_user/1 with valid data creates a user" do
      expected = build(:user)
      assert {:ok, %User{} = actual} = Accounts.create_user(expected)
      compare_users(expected, actual)
      assert actual.password != expected.password
    end

    test "create_user/1 with invalid data returns error changeset" do
      attrs =
        build(:user)
        |> Map.put(:email, "bademail")

      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
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
      original = user_fixture()

      attrs =
        build(:user)
        |> Map.put(:email, "world@hello.com")
        |> Map.put(:name, "Frodo")
        |> Map.put(:bio, "Ring Bearer")
        |> Map.put(:username, "frodo")
        |> Map.put(:password, "aPa$$w0rd")

      assert {:ok, %User{} = actual} = Accounts.update_user(original, attrs)
      compare_users(attrs, actual)
      assert original.password != actual.password
      assert actual.password != attrs.password
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()

      attrs =
        build(:user)
        |> Map.put(:username, "k")

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, attrs)
      assert Accounts.get_user(user.id) == {:ok, user}
    end

    def compare_users(a, b) do
      assert a.bio == b.bio
      assert a.email == b.email
      assert a.name == b.name
      assert a.username == b.username
    end
  end

  describe "authors" do
    alias BlogCore.Accounts.Author

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        build(:author, attrs)
        |> Accounts.create_author()

      author
    end

    test "create_author/1 with valid data creates a author" do
      attrs = build(:author)
      assert {:ok, %Author{} = actual} = Accounts.create_author(attrs)
      compare_authors(attrs, actual)
      assert actual.user.password != attrs.user.password
    end

    test "create_author/1 with invalid data returns error changeset" do
      attrs = build(:author)
              |> put_in([:user, :password], "weaaaaak")
      assert {:error, %Ecto.Changeset{}} = Accounts.create_author(attrs)
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
      original = author_fixture()
      attrs = build(:author)
              |> Map.put(:user, Map.from_struct(original.user))
              |> put_in([:user, :password], "Th3 Str0nge$t")

      assert {:ok, %Author{} = actual} = Accounts.update_author(original, attrs)
      compare_authors(attrs, actual)
      assert attrs.user.password != original.user.password
      assert attrs.user.password != actual.user.password
    end

    test "update_author/2 with invalid data returns error changeset" do
      original = author_fixture()
      attrs = build(:author)
              |> Map.put(:user, Map.from_struct(original.user))
              |> put_in([:user, :password], "weaaaaak")

      assert {:error, %Ecto.Changeset{}} = Accounts.update_author(original, attrs)
      assert Accounts.get_author(original.id) == {:ok, original}
    end

    def compare_authors(a, b) do
      compare_users(a.user, b.user)
    end
  end
end
