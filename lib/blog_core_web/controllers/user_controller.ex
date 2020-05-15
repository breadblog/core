defmodule BlogCoreWeb.UserController do
  use BlogCoreWeb, :controller

  alias BlogCore.Accounts

  action_fallback BlogCoreWeb.FallbackController

  def update(conn, %{"user" => %{"id" => id} = user_params}) do
      with {:ok, user} <- Accounts.get_user(id),
           {:ok, user} <- Accounts.update_user(user, user_params)
      do
        json(conn, user)
      end
  end
end
