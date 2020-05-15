defmodule BlogCore.Repo.Migrations.AddPostPublished do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :published, :boolean
    end
  end
end
