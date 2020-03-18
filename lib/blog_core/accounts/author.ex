defmodule BlogCore.Accounts.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.User
  alias BlogCore.Contents.Post

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
    |> cast_assoc(:user, with: &User.changeset/2)
    |> validate_required([:user])
  end

  defimpl Jason.Encoder, for: [BlogCore.Accounts.Author] do
    def encode(struct, opts) do
      struct
      |> Map.from_struct()
      |> Map.take([:user, :id])
      |> Jason.Encode.map(opts)
    end
  end
end
