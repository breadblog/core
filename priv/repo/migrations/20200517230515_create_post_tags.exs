defmodule Core.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags, primary_key: false) do
      add :post_id, references(:posts, on_delete: :delete_all, type: :binary_id)
      add :tag_id, references(:tags, on_delete: :delete_all, type: :binary_id)
    end
  end
end
