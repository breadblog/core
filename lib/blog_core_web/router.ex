defmodule BlogCoreWeb.Router do
  use BlogCoreWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug BlogCoreWeb.Plugs.FetchUser
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard"
    end
  end
end
