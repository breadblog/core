defmodule BlogCore.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogCore.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :bio, :string
    field :email, :string
    field :name, :string
    field :username, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(rename_password(attrs), [:name, :username, :email, :bio, :password_hash])
    |> validate_required([:name, :username, :password_hash, :email])
    |> validate_length(:bio, max: 512)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email, max: 48)
    |> validate_length(:name, min: 2, max: 48)
    |> validate_format(:username, ~r/^[a-zA-Z0-9]*$/)
    |> validate_length(:username, min: 5, max: 16)
    |> unique_constraint(:username)
    |> validate_format(:password_hash, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])/)
    |> validate_length(:password_hash, min: 8, max: 64)
    |> update_change(:password_hash, &Argon2.hash_pwd_salt/1)
  end

  defp rename_password(attrs) do
    case Map.get(attrs, :password) do
      nil -> attrs
      password -> attrs
      |> Map.drop([:password])
      |> Map.put(:password_hash, password)
    end
  end
end
