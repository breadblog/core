defmodule BlogCoreWeb.UserController do
  use BlogCoreWeb, :controller

  alias BlogCore.Accounts
  alias BlogCore.Accounts.User

  action_fallback BlogCoreWeb.FallbackController

  def update(conn, %{"id" => id, "user" => user_params}) do
    result = Accounts.get_user(id)
    |> Monad.map(&Accounts.update_user(&1, user_params))
    |> Monad.unwrap()

    with {:ok, %User{} = user} <- result do
      render(conn, "show.json", user: user)
    end
  end
end
