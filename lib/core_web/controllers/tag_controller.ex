defmodule CoreWeb.TagController do
  use CoreWeb, :controller

  def index(conn, _params) do

  end

  def show(conn, %{"id" => id}) do
    json(conn, %{id: id})
  end

  def create(conn) do

  end

  def update(conn, _params) do

  end

  def delete(conn, _params) do

  end

end
