defmodule BlogCoreWeb.UserController do
  use BlogCoreWeb, :controller

  alias BlogCore.Accounts
  alias BlogCore.Accounts.User
  alias Monad.Maybe
  alias Monad.Result

  action_fallback BlogCoreWeb.FallbackController

  def update(conn, %{"id" => id} = user_params) do
    result = id
    |> Maybe.from
    |> Result.from_maybe(:missing_id)
    |> Monad.and_then(&get_user/1)
    |> Result.and_then(&Accounts.update_user(&1, user_params), :failed_update)
    |> Monad.unwrap()

    case result do
      {:error, :missing_id} -> send_resp(conn, 400, "missing id")
      {:error, :missing_user} -> send_resp(conn, 404, "not found")
      {:error, _} -> send_resp(conn, 500, "server error")
      {:ok, user} -> json(conn, user)
    end
  end

  defp get_user(id) do
    id
    |> Accounts.get_user
    |> Maybe.from
    |> Result.from_maybe(:missing_user)
  end
end
