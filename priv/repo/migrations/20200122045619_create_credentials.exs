defmodule Core.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :password, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    execute(
      """
      insert into credentials ( id, user_id, password, inserted_at, updated_at )
      select uuid_generate_v4(), id, password, current_timestamp, current_timestamp from users;
      """,
      """
      update users, credentials
      set users.password = credentials.password
      where users.id = credentials.user_id;
      """
    )
  end
end
