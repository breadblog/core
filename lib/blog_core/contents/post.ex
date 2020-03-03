defmodule BlogCore.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Contents.Tag
  alias BlogCore.Contents.PostTag

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :author_id, :binary_id
    many_to_many :tags, Tag, join_through: PostTag

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body])
    |> validate_required([:title, :description, :body])
  end
end
