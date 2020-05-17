defmodule Core.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Core.Contents.Tag
  alias Core.Accounts.User

  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    belongs_to :author, User
    many_to_many :tags, Tag, join_through: "post_tags"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body])
    |> cast_assoc(:tags)
    |> cast_assoc(:author)
    |> validate_required([:title, :description, :body])
  end
end
