defmodule BlogCore.Contents.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Contents.Post
  alias BlogCore.Contents.Tag

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "post_tags" do
    belongs_to :post, Post
    belongs_to :tag, Tag

    timestamps()
  end

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
