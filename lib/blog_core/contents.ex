defmodule BlogCore.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false

  alias BlogCore.Repo
  alias BlogCore.Contents.Post
  alias BlogCore.Contents.Tag

  # Posts

  def list_posts() do
    Repo.all(
      from p in Post,
      where: p.published == true
    )
  end

  def create_post(attrs \\ %{}) do
    with {:ok, %Post{} = post} <-
           %Post{}
           |> Post.changeset(attrs)
           |> Repo.insert(),
         do: {:ok, post}
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def get_post(id) do
    result =
      Repo.one(
        from p in Post,
          where: [id: ^id]
      )

    case result do
      nil -> {:error, :not_found}
      post -> {:ok, post}
    end
  end

  # Tags

  def list_tags() do
    Repo.all(from(t in Tag))
  end

  def get_tag(id) do
    result =
      Repo.one(
        from t in Tag,
          where: [id: ^id]
      )

    case result do
      nil -> {:error, :not_found}
      tag -> {:ok, tag}
    end
  end

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag(%Tag{} = tag, attrs \\ %{}) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end
end
