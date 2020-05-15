defmodule BlogCoreWeb.Plugs.FetchUser do
  import Plug.Conn
  import Phoenix.Controller

  alias BlogCore.Accounts
  alias BlogCore.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    token = conn
            |> fetch_session
            |> get_session(:token)
    user = if token do
      token
      |> Map.get("user_id")
      |> Accounts.get_user
    end
    case user do
      nil -> conn
      |> assign(:current_user, nil)
      user -> conn
      |> assign(:current_user, user)
    end
  end
end
