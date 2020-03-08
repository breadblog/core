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

    timestamps()
  end

  # TODO: validate the email
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :bio, :password])
    |> validate_required([:name, :username, :password, :email, :bio])
    # valid email
    |> validate_format(:email, ~r/@/)
    # strong password
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})/)
    # unique username
    |> unique_constraint(:username)
    # hash password
    |> update_change(:password, &Argon2.hash_pwd_salt/1)
  end
end
