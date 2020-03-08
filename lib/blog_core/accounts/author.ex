defmodule BlogCore.Accounts.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.User
  alias BlogCore.Accounts.Post

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "authors" do
    belongs_to :user, User, type: :binary_id, primary_key: true, foreign_key: :id, define_field: false
    has_many :posts, Post

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end
end
