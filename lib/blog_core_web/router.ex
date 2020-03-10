defmodule BlogCoreWeb.Router do
  use BlogCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BlogCoreWeb.Plugs.FetchUser
  end

  # public
  scope "/api", BlogCoreWeb do
    pipe_through [:api]

    post "/login", LoginController, :login
    post "/logout", LoginController, :logout
    resources "/author", AuthorController, only: [:show, :index]
  end

  # private
  scope "/api", BlogCoreWeb do
    pipe_through [:api, BlogCoreWeb.Plugs.Authorize]

    resources "/user", UserController, only: [:update]
    resources "/author", AuthorController, only: [:create, :update]
    resources "/user", UserController, only: [:update]
  end
end
