defmodule BlogCoreWeb.TagController do
  use BlogCoreWeb, :controller

  alias BlogCore.Contents
  alias BlogCore.Contents.Tag

  action_fallback BlogCoreWeb.FallbackController

  def index(conn, _params) do
    tags = Contents.list_tags()
    json(conn, tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    with {:ok, %Tag{} = tag} <- Contents.create_tag(tag_params) do
      json(conn, tag)
    end
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    with {:ok, tag = %Tag{}} <- Contents.get_tag(id),
         {:ok, tag = %Tag{}} <- Contents.update_tag(tag, tag_params),
         do: json(conn, tag)
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Tag{} = tag} <- Contents.get_tag(id),
         {:ok, _} <- Contents.delete_tag(tag),
         do: conn
         |> put_status(200)
         |> send_resp
  end
end
