defmodule Core.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Core.Repo
  alias Core.Contents.Tag
  alias Core.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :published, :boolean
    belongs_to :author, User
    many_to_many :tags, Tag, join_through: "post_tags"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    tags =
      Repo.all(
        from t in Tag,
          where: t.name in ^attrs["tags"]
      )

    post
    |> cast(attrs, [:title, :description, :body, :published, :author_id])
    |> cast_assoc(:author)
    |> put_assoc(:tags, tags)
    |> validate_required([:title, :description, :body, :published, :author_id])
    |> validate_length(:title, min: 3, max: 100)
    |> validate_length(:body, min: 0, max: 10000)
  end
end
