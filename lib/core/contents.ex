defmodule Core.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset

  alias Core.Repo
  alias Core.Contents.Tag
  alias Core.Contents.Post
  alias Core.Accounts.User

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
  Returns a list of tags associated with a given post

  ## Examples

    iex> list_post_tags(Repo.get!(Post, "e6a380dc-acf3-4cd8-908c-21317b683b75"))
    [%Tag{}, ...]
  """
  def list_post_tags(%Post{} = post) do
    post
    |> Repo.preload(:tags)
    |> Map.get(:tags, [])
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag(123)
      {:ok, %Tag{}}

      iex> get_tag(456)
      {:error, :not_found}

  """
  def get_tag(id) do
    case Repo.get(Tag, id) do
      %Tag{} = tag -> {:ok, tag}
      _ -> {:error, :not_found}
    end
  end

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

  def create_tag!(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert!()
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
  Deletes a tag.

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
      %Ecto.Changeset{data: %Tag{}}

  """
  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

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

      iex> get_post(123)
      %Post{}

      iex> get_post(456)
      ** (Ecto.NoResultsError)

  """
  def get_post(id) do
    case Repo.get(Post, id) do
      %Post{} = post -> {:ok, post}
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, curr_user = %User{}) do
    create_post_changeset(attrs, curr_user)
    |> Repo.insert()
  end

  def create_post!(attrs \\ %{}, curr_user = %User{}) do
    create_post_changeset(attrs, curr_user)
    |> Repo.insert!()
  end

  defp create_post_changeset(attrs = %{}, curr_user = %User{}) do
    curr_user
    |> Ecto.build_assoc(:posts)
    |> Repo.preload(:tags)
    |> Post.changeset(attrs)
    |> Changeset.put_assoc(:tags, get_post_attr_tags(attrs))
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
    |> Repo.preload(:tags)
    |> Changeset.put_assoc(:tags, get_post_attr_tags(attrs))
    |> Repo.update()
  end

  @doc """
  Deletes a post.

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
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  defp get_post_attr_tags(attrs) do
    tag_ids =
      attrs
      |> Map.get("tags", [])
      |> Enum.map(&Map.get(&1, "id"))

    Repo.all(
      from t in Tag,
        where: t.id in ^tag_ids
    )
  end
end
