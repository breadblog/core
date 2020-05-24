defmodule CoreWeb.PostControllerTest do
  use CoreWeb.ConnCase

  import Core.Factory
  alias Core.Contents
  alias Core.Contents.Post
  alias Core.Accounts.User

  def fixture(:post, %User{} = user) do
    {:ok, post} = Contents.create_post(build(:post), user)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    # TODO: re-enable after #8
    # test "lists all published posts", %{conn: conn} do
    #   conn = get(conn, Routes.post_path(conn, :index))
    #   assert json_response(conn, 200)["data"] == []
    # end

    # test "does not list unpublished posts", %{conn: conn} do
    #   conn = get(conn, Routes.post_path(conn, :index))
    #   assert json_response(conn, 200)["data"]
    # end
  end

  describe "create post" do
    @tag :authenticated
    test "renders post when data is valid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: build(:post))
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some body",
               "description" => "some description",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: build(:post, :invalid))
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "requires authentication", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: build(:post))
      assert json_response(conn, 401)["errors"]["detail"] == "Unauthorized"
    end
  end

  describe "update post" do
    setup [:create_post]

    @tag :authenticated
    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: build(:post, :update))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.post_path(conn, :show, id))

      assert %{
               "id" => id,
               "body" => "some updated body",
               "description" => "some updated description",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: build(:post, :invalid))
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "requires authentication", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: build(:post, :update))
      assert json_response(conn, 401)["errors"]["detail"] == "Unauthorized"
    end
  end

  describe "delete post" do
    setup [:create_post]

    @tag :authenticated
    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert response(conn, 204)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end

    test "requires authentication", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert json_response(conn, 401)["errors"]["detail"] == "Unauthorized"
    end
  end

  defp create_post(_) do
    assert {:ok, curr_user} = Core.Accounts.get_user(%{"username" => "frodo"})
    post = fixture(:post, curr_user)
    %{post: post}
  end
end
