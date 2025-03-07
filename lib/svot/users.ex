defmodule Svot.Users do
  alias Svot.{User, Repo}

  def create_user(attrs) do
    attrs
    |> User.changeset()
    |> Repo.insert()
    |> case do
      {:ok, _user} -> :ok
      {:error, _changeset} -> :error
    end
  end
end
