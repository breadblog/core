defmodule BlogCoreWeb.ErrorView do
  use BlogCoreWeb, :view

  def render("400.json", %{changeset: changeset}) do
    # TODO: is this what I want?
    changeset
  end

  def render("401.json", _assigns) do
    "unauthorized"
  end

  def render("403.json", _assigns) do
    "forbidden"
  end

  def render("404.json", _assigns) do
    "not found"
  end

  def render("500.json", _assigns) do
    "internal server error"
  end
end
