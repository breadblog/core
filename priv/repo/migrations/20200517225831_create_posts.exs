defmodule Core.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :description, :string
      add :body, :string
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:author_id])
  end
end
