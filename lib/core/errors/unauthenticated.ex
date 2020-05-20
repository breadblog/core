defmodule Core.Errors.Unauthenticated do
  defexception [message: "unauthorized"]

  defimpl Plug.Exception, for: Core.Errors.Unauthenticated do
    def actions(_), do: []
    def status(_), do: 401
  end
end
