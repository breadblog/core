defmodule BlogCoreWeb.Router do
  use BlogCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlogCoreWeb do
    pipe_through :api
  end
end
