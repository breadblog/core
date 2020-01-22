defmodule Core.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset
  alias Core.Accounts.User
  alias Core.Accounts.Role

  @primary_key false
  @foreign_key_type :binary_id
  schema "user_roles" do
    belongs_to :user, User
    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
  end
end
