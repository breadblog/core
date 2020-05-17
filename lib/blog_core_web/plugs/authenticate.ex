defmodule BlogCoreWeb.Plugs.Authorize do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns[:current_user]
    case current_user do
      nil -> conn
      |> Phoenix.Controller.render(BlogCoreWeb.ErrorView, "401.json")
      _ -> conn
    end
  end
end
