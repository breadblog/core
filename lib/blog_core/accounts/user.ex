defmodule BlogCore.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.Author

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :bio, :string
    field :email, :string
    field :name, :string
    field :username, :string
    has_one :author, Author, foreign_key: :id

    timestamps()
  end

  # TODO: validate the email
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :bio])
    |> validate_required([:name, :username, :email, :bio])
    |> unique_constraint(:username)
  end
end
