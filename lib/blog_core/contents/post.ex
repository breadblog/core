defmodule BlogCore.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.Author
  alias BlogCore.Contents.Tag
  alias BlogCore.Contents.Comment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :published, :boolean
    many_to_many :tags, Tag, join_through: "post_tags"
    belongs_to :author, Author
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body, :published])
    |> cast_assoc(:tags, required: true)
    |> cast_assoc(:author, required: true)
    |> cast_assoc(:comments, required: true)
    |> validate_required([:title, :description, :body, :published])
  end
end
