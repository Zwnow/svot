defmodule SvotWeb.LoginController do
  use SvotWeb, :controller
  alias Svot.{Users, User}

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, :index, layout: false, changeset: changeset)
  end

  def login(conn, %{"user" => user_params}) do
    %{"username" => username} = user_params
    case Users.get_user_by_name(username) do
      nil ->
        changeset = User.changeset(%User{})
        render(conn, :index, layout: false, changeset: changeset)
      user ->
        conn
        |> put_session(:user_uuid, user.uuid)
        |> redirect(to: "/")
    end
  end
end
