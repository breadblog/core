defmodule BlogCore.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id)
      add :tag_id, references(:tags, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:post_tags, [:post_id])
    create index(:post_tags, [:tag_id])
  end
end
