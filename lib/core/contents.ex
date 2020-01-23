defmodule Core.Contents do
  @moduledoc """
  The Contents context.
  """

  # Things I want to be able to do:
  #   * create post (author)
  #   * fetch published author posts (public)
  #   * fetch all author posts (author)
  #   * create tag (admin)
  #   * update tag (admin)

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Contents.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  alias Core.Contents.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  alias Core.Contents.PostTag

  @doc """
  Returns the list of post_tags.

  ## Examples

      iex> list_post_tags()
      [%PostTag{}, ...]

  """
  def list_post_tags do
    Repo.all(PostTag)
  end

  @doc """
  Creates a post_tag.

  ## Examples

      iex> create_post_tag(%{field: value})
      {:ok, %PostTag{}}

      iex> create_post_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post_tag(attrs \\ %{}) do
    %PostTag{}
    |> PostTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a PostTag.

  ## Examples

      iex> delete_post_tag(post_tag)
      {:ok, %PostTag{}}

      iex> delete_post_tag(post_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_tag(%PostTag{} = post_tag) do
    Repo.delete(post_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_tag changes.

  ## Examples

      iex> change_post_tag(post_tag)
      %Ecto.Changeset{source: %PostTag{}}

  """
  def change_post_tag(%PostTag{} = post_tag) do
    PostTag.changeset(post_tag, %{})
  end
end
