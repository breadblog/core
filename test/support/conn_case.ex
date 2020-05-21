defmodule CoreWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use CoreWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  @default_opts [
    store: :cookie,
    key: "Dz820gfY2Kej7muxQqhmQLI727tXWN3M",
    encryption_salt: "XVAgHLAz9ZvIWGSkWAhzBOJKMoz8TvFG",
    signing_salt: "signing salt"
  ]
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import CoreWeb.ConnCase

      alias CoreWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint CoreWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Core.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, {:shared, self()})
    end

    if tags[:authenticated] do
      username = "frodo"
      password = "St1ngs?!"

      {:ok, token} = Core.Accounts.login(username, password)

      conn =
        Phoenix.ConnTest.build_conn()
        |> Plug.Session.call(@signing_opts)
        |> Plug.Conn.fetch_session()
        |> Plug.Conn.put_session(:token, token)

      {:ok, conn: conn}
    else
      {:ok, conn: Phoenix.ConnTest.build_conn()}
    end
  end
end
