defmodule BlogCoreWeb.RoleController do
  use BlogCoreWeb, :controller

  alias BlogCore.Accounts
  alias BlogCore.Accounts.Role

  action_fallback BlogCoreWeb.FallbackController

  def index(conn, _params) do
    roles = Accounts.list_roles()
    render(conn, "index.json", roles: roles)
  end

  def create(conn, %{"role" => role_params}) do
    with {:ok, %Role{} = role} <- Accounts.create_role(role_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.role_path(conn, :show, role))
      |> render("show.json", role: role)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Accounts.get_role!(id)
    render(conn, "show.json", role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Accounts.get_role!(id)

    with {:ok, %Role{} = role} <- Accounts.update_role(role, role_params) do
      render(conn, "show.json", role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Accounts.get_role!(id)

    with {:ok, %Role{}} <- Accounts.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
