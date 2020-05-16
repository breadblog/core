defmodule BlogCoreWeb.UserController do
  use BlogCoreWeb, :controller

  action_fallback BlogCoreWeb.FallbackController

  def login(conn, %{"username" => username, "password" => password}) do
    case Accounts.login(username, password) do
      {:ok, token} -> conn
        |> fetch_session
        |> put_session(:token, token)
        |> render("200.json")
      {:error, _err} -> conn
        |> render("401.json")
    end
  end

  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:token)
    |> render("200.json")
  end

  def index(conn, _params) do
    users =
      Accounts.list_users()
      |> Enum.map(&Accounts.display(&1, conn.assigns.current_user))
      |> Enum.into([])

    json(conn, %{users: users})
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      render(conn, %{user: user, curr_user: conn.assigns.curr_user})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, author} <- Accounts.get_author(id) do
      json(conn, %{author: Accounts.display(author, conn.assigns.current_user)})
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do

  end
end
