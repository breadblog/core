defmodule BlogCoreWeb.Plugs.Authorize do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns[:current_user]
    case current_user do
      nil -> conn
      |> put_status(:unauthorized)
      |> render("401.json")
      _ -> conn
    end
  end
end
