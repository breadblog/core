defmodule Core.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :content, :string
    field :deleted, :boolean, default: false
    belongs_to :post, Core.Post
    belongs_to :user, Core.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :deleted])
    |> validate_required([:content, :deleted])
  end
end
