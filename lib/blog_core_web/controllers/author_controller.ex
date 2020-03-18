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
    {:ok, author} = case Accounts.create_author(author_params)
    json(conn, author)
  end

  def show(conn, %{"id" => id}) do
    {:ok, author} = Accounts.get_author(id)
    json(conn, author)
  end
end
