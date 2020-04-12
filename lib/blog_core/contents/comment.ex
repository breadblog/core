defmodule BlogCore.Contents.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.User
  alias BlogCore.Contents.Post

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :value, :string
    belongs_to :user, User
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
