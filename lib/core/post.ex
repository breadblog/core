defmodule Core.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :body, :string
    field :description, :string
    field :published, :boolean, default: false
    field :title, :string
    has_many :comments, Core.Comment
    many_to_many :tags, Core.Tag, join_through: "post_tags"
    belongs_to :user, Core.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body, :published])
    |> validate_required([:title, :description, :body, :published])
  end
end
