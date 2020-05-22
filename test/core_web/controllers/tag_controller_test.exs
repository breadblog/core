defmodule CoreWeb.TagControllerTest do
  use CoreWeb.ConnCase

  alias Core.Contents
  alias Core.Contents.Tag

  @create_attrs %{
    description: "some description",
    name: "somename"
  }
  @update_attrs %{
    description: "some updated description",
    name: "updatename"
  }
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:tag) do
    {:ok, tag} = Contents.create_tag(@create_attrs)
    tag
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tags", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :index))

      data = json_response(conn, 200)["data"]
      assert length(data) == 4
      assert Enum.find(data, &(&1["name"] == "elixir"))
      assert Enum.find(data, &(&1["name"] == "elm"))
      assert Enum.find(data, &(&1["name"] == "javascript"))
      assert Enum.find(data, &(&1["name"] == "privacy"))
    end
  end

  describe "create tag" do
    @tag :authenticated
    test "renders tag when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "somename"
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tag" do
    setup [:create_tag]

    @tag :authenticated
    test "renders tag when data is valid", %{conn: conn, tag: %Tag{id: id} = tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "updatename"
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, tag: tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tag" do
    setup [:create_tag]

    @tag :authenticated
    test "deletes chosen tag", %{conn: conn, tag: tag} do
      conn = delete(conn, Routes.tag_path(conn, :delete, tag))
      assert response(conn, 204)

      conn = get(conn, Routes.tag_path(conn, :show, tag))
      assert json_response(conn, 404) == %{"errors" => %{"detail" => "Not Found"}}
    end
  end

  defp create_tag(_) do
    tag = fixture(:tag)
    %{tag: tag}
  end
end
