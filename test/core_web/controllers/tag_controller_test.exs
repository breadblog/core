defmodule CoreWeb.TagControllerTest do
  use CoreWeb.ConnCase

  import Core.Factory
  alias Core.Contents
  alias Core.Contents.Tag

  def fixture(:tag) do
    {:ok, tag} = Contents.create_tag(build(:tag))
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
      attrs = build(:tag)
      conn = post(conn, Routes.tag_path(conn, :create), tag: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      expected = %{
        "id" => id,
        "description" => attrs["description"],
        "name" => attrs["name"]
      }

      assert ^expected = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: build(:tag, :invalid))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tag" do
    setup [:create_tag]

    @tag :authenticated
    test "renders tag when data is valid", %{conn: conn, tag: %Tag{id: id} = tag} do
      attrs = build(:tag, :update)
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      expected = %{
        "id" => id,
        "description" => attrs["description"],
        "name" => attrs["name"]
      }

      assert ^expected = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, tag: tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: build(:tag, :invalid))
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
