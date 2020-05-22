defmodule CoreWeb.PostController do
  use CoreWeb, :controller

  alias Core.Contents
  alias Core.Contents.Post

  action_fallback CoreWeb.FallbackController

  plug CoreWeb.Plugs.Authenticate when action in [:create, :update, :delete]

  def index(conn, _params) do
    posts = Contents.list_posts()
    render(conn, "index.json", posts: posts, curr_user: conn.assigns.curr_user)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Contents.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- Contents.get_post(id),
         do: render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    with {:ok, post} <- Contents.get_post(id),
         {:ok, %Post{} = post} <- Contents.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, post} <- Contents.get_post(id),
         {:ok, %Post{}} <- Contents.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
