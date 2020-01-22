defmodule CoreWeb.UserRoleView do
  use CoreWeb, :view
  alias CoreWeb.UserRoleView

  def render("index.json", %{user_roles: user_roles}) do
    %{data: render_many(user_roles, UserRoleView, "user_role.json")}
  end

  def render("show.json", %{user_role: user_role}) do
    %{data: render_one(user_role, UserRoleView, "user_role.json")}
  end

  def render("user_role.json", %{user_role: user_role}) do
    %{id: user_role.id}
  end
end
