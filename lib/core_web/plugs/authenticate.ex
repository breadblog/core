defmodule CoreWeb.Plugs.Authenticate do
  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns[:current_user]
    case current_user do
      nil -> raise Core.Unauthenticated
      _ -> conn
    end
  end
end
