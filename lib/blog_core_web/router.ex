defmodule BlogCoreWeb.Router do
  import Phoenix.LiveDashboard.Router
  use BlogCoreWeb, :router

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

    post "user/login", UserController, :login
    post "user/logout", UserController, :logout
    resources "/user", UserController, only: [:show, :index]
  end

  # private
  scope "/api", BlogCoreWeb do
    pipe_through [:api, BlogCoreWeb.Plugs.Authorize]

    resources "/user", UserController, only: [:create, :update]
  end

  # dashboard
  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard"
    end
  end

  # TODO: do I need this?
  # scope "/", BlogCoreWeb do
  #   get "/*path", NotFoundController, :index
  #   put "/*path", NotFoundController, :index
  #   post "/*path", NotFoundController, :index
  #   patch "/*path", NotFoundController, :index
  #   delete "/*path", NotFoundController, :index
  # end
end
