defmodule BlogCore.ContentsTest do
  use BlogCore.DataCase, async: true
  import BlogCore.Factory

  alias BlogCore.Contents

  describe "tags" do
    # alias BlogCore.Contents.Tag

    # @update_attrs %{description: "some updated description", name: "some updated name"}
    # @invalid_attrs %{description: nil, name: nil}

    # def tag_fixture(attrs \\ %{}) do
    #   {:ok, tag} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Contents.create_tag()

    #   tag
    # end

    # test "list_tags/0 returns all tags" do
    #   tag = tag_fixture()
    #   assert Contents.list_tags() == [tag]
    # end

    # test "get_tag!/1 returns the tag with given id" do
    #   tag = tag_fixture()
    #   assert Contents.get_tag!(tag.id) == tag
    # end

    # test "create_tag/1 with valid data creates a tag" do
    #   assert {:ok, %Tag{} = tag} = Contents.create_tag(@valid_attrs)
    #   assert tag.description == "some description"
    #   assert tag.name == "some name"
    # end

    # test "create_tag/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Contents.create_tag(@invalid_attrs)
    # end

    # test "update_tag/2 with valid data updates the tag" do
    #   tag = tag_fixture()
    #   assert {:ok, %Tag{} = tag} = Contents.update_tag(tag, @update_attrs)
    #   assert tag.description == "some updated description"
    #   assert tag.name == "some updated name"
    # end

    # test "update_tag/2 with invalid data returns error changeset" do
    #   tag = tag_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Contents.update_tag(tag, @invalid_attrs)
    #   assert tag == Contents.get_tag!(tag.id)
    # end

    # test "delete_tag/1 deletes the tag" do
    #   tag = tag_fixture()
    #   assert {:ok, %Tag{}} = Contents.delete_tag(tag)
    #   assert_raise Ecto.NoResultsError, fn -> Contents.get_tag!(tag.id) end
    # end

    # test "change_tag/1 returns a tag changeset" do
    #   tag = tag_fixture()
    #   assert %Ecto.Changeset{} = Contents.change_tag(tag)
    # end
  end

  describe "posts" do
    alias BlogCore.Contents.Post

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        build(:post, attrs)
        |> Contents.create_post()

      post
    end

    test "list_posts/0 returns all published posts" do
      expected = post_fixture(%{published: true})
      list = Contents.list_posts()
      assert length(list) == 1
      [actual] = list
      compare_posts(expected, actual)
    end

    test "list_posts/0 does not return unpublished posts" do
      post_fixture(%{published: false})
      assert Contents.list_posts() == []
    end

    test "get_post/1 returns the post with given id" do
      expected = post_fixture()
      assert {:ok, actual} = Contents.get_post(expected.id)
      compare_posts(expected, actual)
    end

    test "get_post/1 returns :not_found" do
      assert Contents.get_post("30d4ca72-14c0-463b-97cf-8b84dc542d59") == {:error, :not_found}
    end

    test "create_post/1 with valid data creates a post" do
      attrs = build(:post)
      assert {:ok, %Post{} = actual} = Contents.create_post(attrs)
      compare_posts(attrs, actual)
    end

    test "create_post/1 with invalid data returns error changeset" do
      attrs = build(:post, %{title: ""})

      assert {:error, %Ecto.Changeset{}} = Contents.create_post(attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      attrs = build(:post, %{
        title: "a changed title",
        body: "a changed post body",
        description: "a changed post description",
        author: post.author,
        author_id: post.author.id,
        comments: post.comments,
        tags: post.tags
      })
      assert {:ok, %Post{} = post} = Contents.update_post(post, attrs)
      compare_posts(post, attrs)
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      attrs = build(:post)
      assert {:error, %Ecto.Changeset{}} = Contents.update_post(post, attrs)
      assert {:ok, actual} = Contents.get_post(post.id)
      compare_posts(post, actual)
    end
  end

  defp compare_posts(%{} = a, %{} = b) do
    assert a.title == b.title
    assert a.body == b.body
    assert a.description == b.description
    assert length(a.tags) == length(b.tags)
    Enum.zip(a.tags, b.tags)
    |> Enum.map(fn {x, y} -> compare_tags(x, y) end)
    assert length(a.comments) == length(b.comments)
    Enum.zip(a.comments, b.comments)
    |> Enum.map(fn {x, y} -> compare_comments(x, y) end)
  end

  defp compare_comments(%{} = a, %{} = b) do
    assert a.value == b.value
  end

  defp compare_tags(%{} = a, %{} = b) do
    assert a.name == b.name
    assert a.description == b.description
  end
end
