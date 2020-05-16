defmodule BlogCoreWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BlogCoreWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogCoreWeb.ChangesetView)
    |> json(%{"json" => changeset})
    |> render("400.json", changeset: changeset)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> send_resp(403, "Unauthorized")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> send_resp(404, "Not Found")
  end

  def call(conn, _) do
    conn
    |> send_resp(500, "Internal Server Error")
  end
end
