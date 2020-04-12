defmodule BlogCore.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.Author
  alias BlogCore.Contents.Tag
  alias BlogCore.Contents.PostTag
  alias BlogCore.Contents.Comment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :published, :boolean
    many_to_many :tags, Tag, join_through: PostTag
    has_one :author, Author
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body])
    |> cast_assoc(:tags, with: &Tag.changeset/2)
    |> cast_assoc(:author, with: &Author.changeset/2)
    |> cast_assoc(:coments, with: &Comment.changeset/2)
    |> validate_required([:title, :description, :body, :tags, :author, :comments])
  end
end
