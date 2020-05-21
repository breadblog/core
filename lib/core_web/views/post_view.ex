defmodule CoreWeb.PostView do
  use CoreWeb, :view
  alias CoreWeb.PostView
  alias Core.Accounts.User

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, PostView, "post.json")}
  end

  def render("post.json", %{post: post, curr_user: curr_user}) do
    author = post.author

    case curr_user do
      %User{id: ^author} ->
        %{
          id: post.id,
          title: post.title,
          description: post.description,
          body: post.body,
          published: post.published
        }

      _ ->
        %{
          id: post.id,
          title: post.title,
          description: post.description,
          body: post.body
        }
    end
  end
end
