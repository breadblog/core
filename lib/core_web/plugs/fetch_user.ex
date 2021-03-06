defmodule CoreWeb.Plugs.FetchUser do
  import Plug.Conn

  alias Core.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    token =
      conn
      |> fetch_session
      |> get_session(:token)

    user =
      if token do
        token
        |> Core.Token.verify_and_validate!()
        |> Map.get("user_id")
        |> Accounts.get_user()
      end

    case user do
      {:ok, user} ->
        conn
        |> assign(:curr_user, user)

      _ ->
        conn
        |> assign(:curr_user, nil)
    end
  end
end
