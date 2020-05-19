defmodule Core.Unauthenticated do
  defexception [message: "unauthorized", plug_status: 401]
end
