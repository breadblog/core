defmodule CoreWeb.TagController do
  use CoreWeb, :controller

  alias Core.Contents
  alias Core.Contents.Tag

  action_fallback CoreWeb.FallbackController

  plug CoreWeb.Plugs.Authenticate when action in [:create, :update, :delete]

  def index(conn, _params) do
    tags = Contents.list_tags()
    render(conn, "index.json", tags: tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    with {:ok, %Tag{} = tag} <- Contents.create_tag(tag_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tag_path(conn, :show, tag))
      |> render("show.json", tag: tag)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, tag} <- Contents.get_tag(id),
         do: render(conn, "show.json", tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    with {:ok, tag} <- Contents.get_tag(id),
         {:ok, %Tag{} = tag} <- Contents.update_tag(tag, tag_params) do
      render(conn, "show.json", tag: tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, tag} <- Contents.get_tag(id),
         {:ok, %Tag{}} <- Contents.delete_tag(tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
