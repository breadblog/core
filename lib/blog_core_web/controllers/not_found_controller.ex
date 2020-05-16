# TODO: do I need this?
defmodule BlogCoreWeb.NotFoundController do
  use BlogCoreWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(404, "Not Found")
  end
end
