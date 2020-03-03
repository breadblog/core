defmodule BlogCore.ContentsTest do
  use BlogCore.DataCase

  alias BlogCore.Contents

  describe "comments" do
    alias BlogCore.Contents.Comment

    @valid_attrs %{value: "some value"}
    @update_attrs %{value: "some updated value"}
    @invalid_attrs %{value: nil}

    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_comment()

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Contents.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Contents.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      assert {:ok, %Comment{} = comment} = Contents.create_comment(@valid_attrs)
      assert comment.value == "some value"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{} = comment} = Contents.update_comment(comment, @update_attrs)
      assert comment.value == "some updated value"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_comment(comment, @invalid_attrs)
      assert comment == Contents.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Contents.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Contents.change_comment(comment)
    end
  end

  describe "tags" do
    alias BlogCore.Contents.Tag

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
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
      assert Contents.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Contents.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Contents.create_tag(@valid_attrs)
      assert tag.description == "some description"
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Contents.update_tag(tag, @update_attrs)
      assert tag.description == "some updated description"
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_tag(tag, @invalid_attrs)
      assert tag == Contents.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Contents.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Contents.change_tag(tag)
    end
  end

  describe "posts" do
    alias BlogCore.Contents.Post

    @valid_attrs %{body: "some body", description: "some description", title: "some title"}
    @update_attrs %{body: "some updated body", description: "some updated description", title: "some updated title"}
    @invalid_attrs %{body: nil, description: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Contents.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Contents.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Contents.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.description == "some description"
      assert post.title == "some title"
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
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_post(post, @invalid_attrs)
      assert post == Contents.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Contents.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Contents.change_post(post)
    end
  end

  describe "post_tags" do
    alias BlogCore.Contents.PostTag

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def post_tag_fixture(attrs \\ %{}) do
      {:ok, post_tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contents.create_post_tag()

      post_tag
    end

    test "list_post_tags/0 returns all post_tags" do
      post_tag = post_tag_fixture()
      assert Contents.list_post_tags() == [post_tag]
    end

    test "get_post_tag!/1 returns the post_tag with given id" do
      post_tag = post_tag_fixture()
      assert Contents.get_post_tag!(post_tag.id) == post_tag
    end

    test "create_post_tag/1 with valid data creates a post_tag" do
      assert {:ok, %PostTag{} = post_tag} = Contents.create_post_tag(@valid_attrs)
    end

    test "create_post_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contents.create_post_tag(@invalid_attrs)
    end

    test "update_post_tag/2 with valid data updates the post_tag" do
      post_tag = post_tag_fixture()
      assert {:ok, %PostTag{} = post_tag} = Contents.update_post_tag(post_tag, @update_attrs)
    end

    test "update_post_tag/2 with invalid data returns error changeset" do
      post_tag = post_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Contents.update_post_tag(post_tag, @invalid_attrs)
      assert post_tag == Contents.get_post_tag!(post_tag.id)
    end

    test "delete_post_tag/1 deletes the post_tag" do
      post_tag = post_tag_fixture()
      assert {:ok, %PostTag{}} = Contents.delete_post_tag(post_tag)
      assert_raise Ecto.NoResultsError, fn -> Contents.get_post_tag!(post_tag.id) end
    end

    test "change_post_tag/1 returns a post_tag changeset" do
      post_tag = post_tag_fixture()
      assert %Ecto.Changeset{} = Contents.change_post_tag(post_tag)
    end
  end
end