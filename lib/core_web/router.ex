defmodule CoreWeb.Router do
  use CoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoreWeb do
    pipe_through :api

    resources "/post", PostController, except: [:new, :edit]
    resources "/user", UserController, except: [:new, :edit]
    resources "/author", AuthorController, except: [:new, :edit]
    resources "/tag", TagController, except: [:new, :edit]
    resources "/comment", CommentController, except: [:new, :edit]
    resources "/error", ErrorController, except: [:new, :edit]
  end
end
