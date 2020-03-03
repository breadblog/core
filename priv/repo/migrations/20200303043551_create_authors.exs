defmodule BlogCore.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors, primary_key: false) do
      add :id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:authors, [:id])
  end
end
