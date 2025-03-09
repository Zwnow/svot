defmodule Svot.UsersTest do
  use ExUnit.Case
  use Svot.DataCase

  alias Svot.Users

  test "create_user" do
    attrs = %{username: "Zwnow"}
    assert {:ok, user} = Users.create_user(attrs)
    assert user.username == "Zwnow"
  end

  test "get_user_by_name" do
    attrs = %{username: "Zwnow"}
    assert {:ok, _user } = Users.create_user(attrs)

    user = Users.get_user_by_name("Zwnow")
    assert user.username == "Zwnow"
  end

 test "update_user" do
    attrs = %{username: "Zwnow"}
    assert {:ok, user } = Users.create_user(attrs)

    attrs = %{username: "Zwnow1"}
    assert {:ok, user} = Users.update_user(user.uuid, attrs)
    assert user.username == "Zwnow1"
  end

  test "delete_user" do
    attrs = %{username: "Zwnow"}
    assert {:ok, user } = Users.create_user(attrs)

    assert {:ok, _user} = Users.delete_user(user.uuid)
    assert nil == Users.get_user_by_name("Zwnow")
  end
end
