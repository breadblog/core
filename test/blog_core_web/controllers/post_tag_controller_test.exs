defmodule BlogCoreWeb.PostTagControllerTest do
  use BlogCoreWeb.ConnCase

  alias BlogCore.Contents
  alias BlogCore.Contents.PostTag

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:post_tag) do
    {:ok, post_tag} = Contents.create_post_tag(@create_attrs)
    post_tag
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all post_tags", %{conn: conn} do
      conn = get(conn, Routes.post_tag_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post_tag" do
    test "renders post_tag when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_tag_path(conn, :create), post_tag: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.post_tag_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_tag_path(conn, :create), post_tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post_tag" do
    setup [:create_post_tag]

    test "renders post_tag when data is valid", %{conn: conn, post_tag: %PostTag{id: id} = post_tag} do
      conn = put(conn, Routes.post_tag_path(conn, :update, post_tag), post_tag: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.post_tag_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, post_tag: post_tag} do
      conn = put(conn, Routes.post_tag_path(conn, :update, post_tag), post_tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post_tag" do
    setup [:create_post_tag]

    test "deletes chosen post_tag", %{conn: conn, post_tag: post_tag} do
      conn = delete(conn, Routes.post_tag_path(conn, :delete, post_tag))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_tag_path(conn, :show, post_tag))
      end
    end
  end

  defp create_post_tag(_) do
    post_tag = fixture(:post_tag)
    {:ok, post_tag: post_tag}
  end
end
