defmodule CoreWeb.PostView do
  use CoreWeb, :view
  alias CoreWeb.PostView
  alias CoreWeb.TagView
  alias Core.Accounts.User

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, PostView, "post.json")}
  end

  def render("show.json", %{post: post, curr_user: _curr_user} = assigns) do
    if post != nil do
      %{data: render("post.json", assigns)}
    end
  end

  def render("post.json", %{post: post, curr_user: curr_user}) do
    author = post.author_id

    case curr_user do
      %User{id: ^author} ->
        %{
          id: post.id,
          title: post.title,
          description: post.description,
          body: post.body,
          published: post.published,
          author_id: post.author_id,
          tags: render_many(post.tags, TagView, "tag.json")
        }

      _ ->
        render("post.json", %{post: post})
    end
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      description: post.description,
      body: post.body,
      author_id: post.author_id,
      tags: render_many(post.tags, TagView, "tag.json")
    }
  end
end
