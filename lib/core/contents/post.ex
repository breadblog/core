defmodule Core.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Core.Accounts.User
  alias Core.Contents.Tag

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    # TODO: enforce that user is an author
    belongs_to :author, User, references: :author_id
    many_to_many :tags, Tag, join_through: "post_tags"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body])
    |> validate_required([:title, :description, :body])
  end
end
