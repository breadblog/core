defmodule CoreWeb.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    curr_user = conn.assigns[:curr_user]

    case curr_user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(CoreWeb.ErrorView)
        |> render("401.json")
        |> halt

      _ ->
        conn
    end
  end
end
