defmodule CoreWeb.Plugs.Authenticate do
  alias Core.Errors

  def init(opts), do: opts

  def call(conn, _opts) do
    curr_user = conn.assigns[:curr_user]
    case curr_user do
      nil -> raise Errors.Unauthenticated
      _ -> conn
    end
  end
end
