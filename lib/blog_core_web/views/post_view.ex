defmodule BlogCoreWeb.PostView do
  use BlogCoreWeb, :view
  alias BlogCoreWeb.PostView

  def render("index.json", %{posts: posts, curr_user: curr_user}) do

  end

  def render("show.json", %{post: post, curr_user: curr_user}) do

  end

  def render("post.json", %{post: post, curr_user: curr_user}) do

  end
end
