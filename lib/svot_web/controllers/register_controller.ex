defmodule SvotWeb.RegisterController do
  use SvotWeb, :controller
  use Phoenix.Component
  alias Svot.{User, Users}

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, :index, layout: false, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, _user} ->
        conn
          |> put_flash(:info, "Erfolg!")
          |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, :index, layout: false, changeset: changeset)
    end
  end
end
