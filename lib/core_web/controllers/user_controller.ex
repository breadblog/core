defmodule CoreWeb.UserController do
  use CoreWeb, :controller

  alias Core.Accounts
  alias Core.Accounts.User

  action_fallback CoreWeb.FallbackController

  plug CoreWeb.Plugs.Authenticate when action in [:create, :update, :delete]

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, token, user} <- Accounts.login(username, password) do
      conn
      |> fetch_session
      |> put_session(:token, token)
      |> render("show.json", user: user)
    end
  end

  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:token)
    |> send_resp(:no_content, "")
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id) do
      conn
      |> render("show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- Accounts.get_user(id),
         {:ok, user} <- Accounts.update_user(user, user_params),
         do: render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id),
         {:ok, %User{}} <- Accounts.delete_user(user),
         do: send_resp(conn, :no_content, "")
  end
end
