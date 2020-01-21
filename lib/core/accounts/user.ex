defmodule Core.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :first_name, :last_name, :password])
    |> validate_required([:username, :first_name, :last_name, :password])
    |> unique_constraint(:username)
    |> update_change(:password, &Bcrypt.hash_pwd_salt/1)
  end
end
