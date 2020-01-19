defmodule Core.Repo.Migrations.AddPostAuthor do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :author, references(:users, on_delete: :nothing, type: :binary_id)
    end
  end
end
