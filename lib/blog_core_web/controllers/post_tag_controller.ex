defmodule BlogCoreWeb.PostTagController do
  use BlogCoreWeb, :controller

  alias BlogCore.Contents
  alias BlogCore.Contents.PostTag

  action_fallback BlogCoreWeb.FallbackController

  def index(conn, _params) do
    post_tags = Contents.list_post_tags()
    render(conn, "index.json", post_tags: post_tags)
  end

  def create(conn, %{"post_tag" => post_tag_params}) do
    with {:ok, %PostTag{} = post_tag} <- Contents.create_post_tag(post_tag_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_tag_path(conn, :show, post_tag))
      |> render("show.json", post_tag: post_tag)
    end
  end

  def show(conn, %{"id" => id}) do
    post_tag = Contents.get_post_tag!(id)
    render(conn, "show.json", post_tag: post_tag)
  end

  def update(conn, %{"id" => id, "post_tag" => post_tag_params}) do
    post_tag = Contents.get_post_tag!(id)

    with {:ok, %PostTag{} = post_tag} <- Contents.update_post_tag(post_tag, post_tag_params) do
      render(conn, "show.json", post_tag: post_tag)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_tag = Contents.get_post_tag!(id)

    with {:ok, %PostTag{}} <- Contents.delete_post_tag(post_tag) do
      send_resp(conn, :no_content, "")
    end
  end
end
