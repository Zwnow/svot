defmodule Svot.Users do
  alias Svot.{User, Repo}

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user(user_uuid) do
    Repo.get(User, user_uuid)
  end

  def update_user(user_uuid, attrs) do
    case get_user(user_uuid) do
      nil -> {:error, "User not found"}
      user ->
        user
        |> User.changeset(attrs)
        |> Repo.update()
    end
  end

  def delete_user(user_uuid) do
    case get_user(user_uuid) do
      nil -> {:error, "User not found"}
      user -> Repo.delete(user)
    end
  end
end
