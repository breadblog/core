defmodule BlogCore.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credentials" do
    field :password, :string
    field :user_id, :binary_id

    timestamps()
  end

  # TODO: hash the password
  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:password, :user_id])
    |> validate_required([:password, :user_id])
  end
end
