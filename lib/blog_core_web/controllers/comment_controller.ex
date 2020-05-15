defmodule BlogCoreWeb.CommentController do
  use BlogCoreWeb, :controller

  alias BlogCore.Contents
  alias BlogCore.Contents.Comment

  action_fallback BlogCoreWeb.FallbackController
end
