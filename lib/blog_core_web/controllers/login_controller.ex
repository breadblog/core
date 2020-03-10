defmodule BlogCoreWeb.LoginController do
  use BlogCoreWeb, :controller

  alias BlogCore.Accounts

  action_fallback BlogCoreWeb.FallbackController

  def login(conn, %{"username" => username, "password" => password}) do
    result = Accounts.login(username, password)
    |> Monad.unwrap()

    case result do
      {:ok, token} -> conn
        |> fetch_session
        |> put_session(:token, token)
        |> send_resp(200, "ok")
      {:error, err} -> conn
        |> send_resp(401, "unauthorized")
    end
  end

  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:token)
    |> send_resp(200, "ok")
  end
end
