defmodule Core.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags) do
      add :post, references(:posts, on_delete: :delete_all, type: :binary_id)
      add :tag, references(:tags, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:post_tags, [:post])
    create index(:post_tags, [:tag])
  end
end
