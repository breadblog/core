defmodule Core.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :user, references(:users, on_delete: :delete_all, type: :binary_id)
      add :role, references(:roles, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:user_roles, [:user])
    create index(:user_roles, [:role])
  end
end
