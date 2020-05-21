defmodule Core.ContentsTest do
  use Core.DataCase

  alias Core.Contents

  describe "tags" do
    alias Core.Contents.Tag

    @valid_attrs %{description: "some description", name: "tagname"}
    @update_attrs %{description: "some updated description", name: "updatename"}
    @invalid_attrs %{description: nil, name: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
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
      assert {:ok, %Tag{} = tag} = Contents.create_tag(@valid_attrs)
      assert tag.description == @valid_attrs.description
      assert tag.name == @valid_attrs.name
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Contents.update_tag(tag, @update_attrs)
      assert tag.description == @update_attrs.description
      assert tag.name == @update_attrs.name
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_tag(tag, @invalid_attrs)
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

    @valid_attrs %{body: "some body", description: "some description", title: "some title", published: true}
    @update_attrs %{
      body: "some updated body",
      description: "some updated description",
      title: "some updated title",
      published: false
    }
    @invalid_attrs %{body: nil, description: nil, title: nil, published: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      posts = Contents.list_posts()
      assert Enum.all?(posts, &(&1 = %Post{}))
      assert length(posts) == 2
      assert Enum.member?(posts, post)
    end

    test "get_post/1 returns the post with given id" do
      post = post_fixture()
      assert Contents.get_post(post.id) == {:ok, post}
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Contents.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.description == "some description"
      assert post.title == "some title"
      assert post.published == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Contents.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.description == "some updated description"
      assert post.title == "some updated title"
      assert post.published == false
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_post(post, @invalid_attrs)
      assert {:ok, post} == Contents.get_post(post.id)
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
end
