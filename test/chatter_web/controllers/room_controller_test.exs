defmodule ChatterWeb.RoomControllerTest do
  use ChatterWeb.ConnCase

  alias Chatter.Talk

  import Chatter.Factory

  @create_attrs %{name: "general", description: "General discussions"}
  @update_attrs %{name: "General", title: "This is for general discussions"}
  @invalid_attrs %{name: nil, description: nil}

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get(conn, Routes.room_path(conn, :index))
      assert html_response(conn, 200) =~ "Welcome to Chat App"
    end
  end

  describe "create room" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @create_attrs)

      assert redirected_to(conn) == Routes.room_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.room_path(conn, :create), room: @invalid_attrs)
      assert html_response(conn, 200) =~ "Add New Room"
    end
  end

  describe "update room" do
    setup do
      room = insert(:room)
      {:ok, conn: build_conn(), room: room}
    end

    test "updates and returns chosen todo when data is valid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @update_attrs)
      assert redirected_to(conn) == Routes.room_path(conn, :show, room)
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, Routes.room_path(conn, :update, room), room: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Room"
    end
  end

  describe "delete room" do
    setup do
      room = insert(:room)
      {:ok, conn: build_conn(), room: room}
    end

    test "deletes room", %{conn: conn, room: room} do
      conn = delete(conn, Routes.room_path(conn, :delete, room))
      assert redirected_to(conn) == Routes.room_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.room_path(conn, :show, room))
      end
    end
  end
 end

