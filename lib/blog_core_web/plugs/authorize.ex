defmodule BlogCoreWeb.Plugs.Authorize do
  import Plug.Conn
  import Phoenix.Controller

  alias BlogCore.Accounts
  alias BlogCore.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns[:current_user]
    case current_user do
      nil -> conn
      |> send_resp(401, "unauthorized")
      |> halt
      _ -> conn
    end
  end
end
