defmodule CoreWeb.Router do
  use CoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoreWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end
end
