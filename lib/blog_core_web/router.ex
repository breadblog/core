defmodule BlogCoreWeb.Router do
  use BlogCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlogCoreWeb do
    pipe_through :api

    # TODO: add endpoints
    post "/login", LoginController, :login
    resources "/user", UserController, only: [:update]
    resources "/author", AuthorController, only: [:create, :show, :index, :update]
  end
end
