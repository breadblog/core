defmodule CoreWeb.Plugs.Authenticate do
  def init(opts), do: opts

  def call(conn, _opts) do
    curr_user = conn.assigns[:curr_user]

    case curr_user do
      nil ->
        conn
        |> Phoenix.Controller.render("401.json")

      _ ->
        conn
    end
  end
end
