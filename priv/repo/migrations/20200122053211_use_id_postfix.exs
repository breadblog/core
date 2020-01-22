defmodule Core.Repo.Migrations.UseIdPostfix do
  use Ecto.Migration

  def change do
    rename table("posts"), :author, to: :author_id
    rename table("post_tags"), :post, to: :post_id
    rename table("post_tags"), :tag, to: :tag_id
    rename table("user_roles"), :user, to: :user_id
    rename table("user_roles"), :role, to: :role_id
  end
end
