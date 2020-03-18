defmodule BlogCoreWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BlogCoreWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{valid: false} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BlogCoreWeb.ChangesetView)
    |> json(%{"json" => changeset})
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> send_resp(403, :unauthorized)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> send_resp(404, :not_found)
  end

  def call(conn, _) do
    conn
    |> send_resp(500, :server_error)
  end
end
