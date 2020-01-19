defmodule Core.Contents.PostTags do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "post_tags" do
    field :post_id, :binary_id
    field :tag_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(post_tags, attrs) do
    post_tags
    |> cast(attrs, [])
    |> validate_required([])
  end
end
