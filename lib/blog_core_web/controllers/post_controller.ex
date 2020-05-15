defmodule BlogCoreWeb.PostController do
  use BlogCoreWeb, :controller

  alias BlogCore.Contents
  alias BlogCore.Contents.Post

  action_fallback BlogCoreWeb.FallbackController

  def index(conn, _params) do
    posts = Contents.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Contents.create_post(post_params) do
      json(conn, post)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Post{} = post} <- Contents.get_post(id) do
      json(conn, post)
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    with {:ok, %Post{} = post} <- Contents.get_post(id),
         {:ok, %Post{} = post} <- Contents.update_post(post, post_params),
         do: json(conn, post)
  end
end
