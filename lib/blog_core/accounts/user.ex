defmodule BlogCore.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

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
    # valid email
    |> validate_format(:email, ~r/@/)
    # strong password
    |> validate_format(:password_hash, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{8,})/)
    # valid username
    |> validate_format(:username, ~r/[a-zA-Z0-9]{5,16}/)
    # unique username
    |> unique_constraint(:username)
    # hash password
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

  defimpl Jason.Encoder, for: [BlogCore.Accounts.User] do
    def encode(struct, opts) do
      struct
      |> Map.from_struct()
      |> Map.take([:bio, :email, :name, :username, :id])
      |> Jason.Encode.map(opts)
    end
  end
end
