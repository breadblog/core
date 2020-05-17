defmodule Core.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :description, :string
    field :title, :string
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :body])
    |> validate_required([:title, :description, :body])
  end
end
