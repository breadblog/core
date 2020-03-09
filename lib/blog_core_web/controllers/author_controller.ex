defmodule BlogCoreWeb.AuthorController do
  use BlogCoreWeb, :controller

  alias BlogCore.Accounts
  alias BlogCore.Accounts.Author

  action_fallback BlogCoreWeb.FallbackController

  def index(conn, _params) do
    authors = Accounts.list_authors()
    json(conn, authors)
  end

  def create(conn, %{"author" => author_params}) do
    result = Accounts.create_author(author_params)
    |> Monad.unwrap()

    case result do
      {:ok, author} -> json(conn, author)
      # TODO: ensure no sensitive info here
      {:error, %{errors: errors}} -> send_resp(conn, 400, errors)
      _ -> send_resp(conn, 500, "failed")
    end
  end

  def show(conn, %{"id" => id}) do
    result = Accounts.get_author(id)
    |> Monad.unwrap

    case result do
      nil -> send_resp(conn, 404, "not found")
      author -> json(conn, author)
    end
  end
end
