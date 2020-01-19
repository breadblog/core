defmodule CoreWeb.Router do
  use CoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoreWeb do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: CoreWeb.Schema

    forward "/", Absinthe.Plug,
      schema: CoreWeb.Schema

  end
end
