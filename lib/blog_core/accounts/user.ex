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
    field :password, :string
    has_one :author, Author, foreign_key: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :bio, :password])
    |> validate_required([:name, :username, :password, :email])
    |> validate_length(:bio, max: 512)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 48)
    |> validate_length(:name, min: 2, max: 48)
    |> validate_format(:username, ~r/^[a-zA-Z0-9]*$/)
    |> validate_length(:username, min: 5, max: 16)
    |> unique_constraint(:username)
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])/)
    |> validate_length(:password, min: 8, max: 64)
    |> update_change(:password, &Argon2.hash_pwd_salt/1)
  end
end
