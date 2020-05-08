defmodule BlogCore.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false

  alias BlogCore.Repo
  alias BlogCore.Contents.Post
  alias BlogCore.Contents.Tag
  alias BlogCore.Accounts
  alias BlogCore.Accounts.Author
  alias BlogCore.Accounts.User

  def list_posts() do
    Repo.all from p in Post,
      where: p.published == :true
  end

  def list_all_author_posts(%Author{} = author) do
    Repo.all from p in Post,
      where: p.author_id == ^author.id
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update
  end

  def get_post(id) do
    result = Repo.one from p in Post,
      where: [id: ^id],
      preload: [:author, :comments]

    case result do
      nil -> {:error, :not_found}
      post -> {:ok, post}
    end
  end

  def list_tags() do
    Repo.all from t in Tag
  end

  def get_tag(id) do
    result = Repo.one from t in Tag,
      where: [id: ^id]

    case result do
      nil -> {:error, :not_found}
      tag -> {:ok, tag}
    end
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert
  end

  def update_tag(%Tag{} = tag, attrs \\ %{}) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def user_id(%Post{} = post) do
    post.author_id
  end

  def display(%Tag{} = tag, _) do
    %{
      "name" => tag.name,
      "description" => tag.description,
    }
  end

  def display(%Post{} = post, nil) do
    if post.published do
      %{
        "body" => post.body,
        "description" => post.description,
        "title" => post.title,
        "tags" => post.tags,
        "author" => Accounts.display(post.author, nil),
      }
    end
  end

  def display(%Post{} = post, %User{} = curr_user) do
    post = Repo.preload post, [:tags, :author, :comments]
    curr_user_id = curr_user.id
    case post do
      %Post{author: %Author{id: ^curr_user_id}} ->
        %{
          body: post.body,
          description: post.description,
          title: post.title,
          published: post.published,
          tags: Enum.map(post.tags, &(display(&1, curr_user))),
          author: Accounts.display(post.author, curr_user),
          comments: Enum.map(post.comments, &(display(&1, curr_user)))
        }
      %Post{published: true} ->
        %{
          body: post.body,
          description: post.description,
          title: post.title,
          published: post.published,
          tags: Enum.map(post.tags, &(display(&1, curr_user))),
          author: Accounts.display(post.author, curr_user),
          comments: Enum.map(post.comments, &(display(&1, curr_user)))
        }
      _ ->
        nil
    end
  end
end
