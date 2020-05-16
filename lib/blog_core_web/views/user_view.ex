defmodule BlogCoreWeb.UserView do
  use BlogCoreWeb, :view
  alias BlogCoreWeb.UserView

  def render("login.json", %{user: user}) do
  end

  def render("logout.json", _assigns) do
  end

  def render("index.json", %{users: users, curr_user: curr_user}) do
  end

  def render("show.json", %{user: user, curr_user: curr_user}) do
  end

  def render("user.json", %{user: user, curr_user: curr_user}) do
  end
end
