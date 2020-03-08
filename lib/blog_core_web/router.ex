defmodule BlogCoreWeb.Router do
  use BlogCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlogCoreWeb do
    pipe_through :api

    # TODO: add endpoints
    # resources "/user", UserController, except: [:new, :edit]
    # resources "/author", AuthorController, except: []
  end
end
