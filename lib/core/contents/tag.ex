defmodule Core.Contents.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Core.Contents.Post

  schema "tags" do
    field :description, :string
    field :name, :string
    many_to_many :posts, Post, join_through: "post_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:description, min: 9, max: 64)
    |> unique_constraint(:name)
  end
end
