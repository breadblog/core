defmodule BlogCoreWeb.Plugs.FetchUser do
  import Plug.Conn
  import Phoenix.Controller

  alias BlogCore.Accounts
  alias BlogCore.Token
  alias Monad.Maybe
  alias Monad.Result

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    result = conn
            |> fetch_session
            |> get_session(:token)
            |> IO.inspect
            |> Maybe.from
            |> IO.inspect
            |> Monad.and_then(&Token.verify_and_validate/1)
            |> IO.inspect
            |> Monad.map(&Map.get(&1, "user_id"))
            |> Monad.and_then(&Accounts.get_user/1)
            |> Monad.unwrap
    case result do
      nil -> conn
      user -> conn
      |> assign(:current_user, user.id)
    end
  end
end
