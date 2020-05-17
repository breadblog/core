defmodule BlogCoreWeb.ApiController do
  use BlogCoreWeb, :controller

  action_fallback BlogCoreWeb.FallbackController

  def index(conn, _params) do
    conn
    |> render("404.json")
  end
end
