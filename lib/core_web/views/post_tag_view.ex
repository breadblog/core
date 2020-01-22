defmodule CoreWeb.PostTagView do
  use CoreWeb, :view
  alias CoreWeb.PostTagView

  def render("index.json", %{post_tags: post_tags}) do
    %{data: render_many(post_tags, PostTagView, "post_tag.json")}
  end

  def render("show.json", %{post_tag: post_tag}) do
    %{data: render_one(post_tag, PostTagView, "post_tag.json")}
  end

  def render("post_tag.json", %{post_tag: post_tag}) do
    %{id: post_tag.id}
  end
end
