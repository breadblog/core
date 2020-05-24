defmodule Core.ContentsTest do
  use Core.DataCase

  import Core.Factory
  alias Core.Contents
  alias Core.Accounts.User

  describe "tags" do
    alias Core.Contents.Tag

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(build(:tag))
        |> Contents.create_tag()

      tag
    end

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      tags = Contents.list_tags()
      assert Enum.all?(tags, &(&1 = %Tag{}))
      assert Enum.member?(tags, tag)
      assert length(tags) == 5
    end

    test "get_tag/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Contents.get_tag(tag.id) == {:ok, tag}
    end

    test "create_tag/1 with valid data creates a tag" do
      attrs = build(:tag)
      assert {:ok, %Tag{} = tag} = Contents.create_tag(attrs)
      assert tag.description == attrs["description"]
      assert tag.name == attrs["name"]
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_tag(build(:tag, :invalid))
    end

    test "update_tag/2 with valid data updates the tag" do
      attrs = build(:tag, :update)
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Contents.update_tag(tag, attrs)
      assert tag.description == attrs["description"]
      assert tag.name == attrs["name"]
    end

    test "update_tag/2 with invalid data returns error changeset" do
      attrs = build(:tag, :invalid)
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_tag(tag, attrs)
      assert {:ok, tag} == Contents.get_tag(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Contents.delete_tag(tag)
      assert {:error, :not_found} == Contents.get_tag(tag.id)
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Contents.change_tag(tag)
    end
  end

  describe "posts" do
    alias Core.Contents.Post

    setup :load_curr_user

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(build(:post))
        |> Contents.create_post(fetch_curr_user())

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      posts = Contents.list_posts()
      assert Enum.all?(posts, &(&1 = %Post{}))
      assert length(posts) == 3
      assert Enum.find(posts, fn p -> p.id == post.id end)
    end

    test "get_post/1 returns the post with given id" do
      post = post_fixture()
      assert {:ok, actual} = Contents.get_post(post.id)
      actual = Repo.preload(actual, :tags)
      assert actual == post
    end

    test "create_post/1 with valid data creates a post", context do
      attrs = build(:post)
      curr_user = context[:curr_user]
      assert {:ok, %Post{} = post} = Contents.create_post(attrs, curr_user)
      assert post.body == attrs["body"]
      assert post.description == attrs["description"]
      assert post.title == attrs["title"]
      assert post.published == attrs["published"]
    end

    test "create_post/1 with invalid data returns error changeset", %{curr_user: curr_user} do
      assert {:error, %Ecto.Changeset{}} = Contents.create_post(build(:post, :invalid), curr_user)
    end

    test "update_post/2 with valid data updates the post" do
      attrs = build(:post, :update)
      post = post_fixture()
      assert {:ok, %Post{} = post} = Contents.update_post(post, attrs)
      assert post.body == attrs["body"]
      assert post.description == attrs["description"]
      assert post.title == attrs["title"]
      assert post.published == attrs["published"]
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_post(post, build(:post, :invalid))
      assert {:ok, actual} = Contents.get_post(post.id)
      assert post == Repo.preload(actual, :tags)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Contents.delete_post(post)
      assert {:error, :not_found} == Contents.get_post(post.id)
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Contents.change_post(post)
    end
  end

  def fetch_curr_user() do
    Repo.one!(
      from User,
        where: [username: "frodo"]
    )
  end

  def load_curr_user(_context) do
    user = fetch_curr_user()

    {:ok, %{curr_user: user}}
  end
end
