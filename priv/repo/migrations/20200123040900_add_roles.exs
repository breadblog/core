defmodule Core.Repo.Migrations.AddRoles do
  use Ecto.Migration

  def change do
    execute(
      """
      insert into roles ( id, name, description, inserted_at, updated_at )
      values ( uuid_generate_v4(), 'admin', 'has escalated permissions', current_timestamp, current_timestamp );
      """,
      """
      delete from roles
      where name = 'author';
      """
    )

    execute(
      """
      insert into roles ( id, name, description, inserted_at, updated_at )
      values ( uuid_generate_v4(), 'author', 'can create blog posts on the platform', current_timestamp, current_timestamp );
      """,
      """
      delete from roles
      where name = 'admin';
      """
    )
  end
end
