defmodule Svot.Incomes do
  import Ecto.{Changeset, Query}
  alias Svot.{Income, Repo}

  def create_income(attrs, user_uuid) do
    %Income{}
    |> Income.changeset(attrs)
    |> put_change(:user_uuid, user_uuid)
    |> Repo.insert()
  end

  def get_income(id, user_uuid) do
    Repo.get_by(Income, uuid: id, user_uuid: user_uuid)
  end

  def update_income(id, user_uuid, attrs) do
    case get_income(id, user_uuid) do
      nil ->
        {:error, "Income not found"}

      income ->
        income
        |> Income.changeset(attrs)
        |> Repo.update()
    end
  end

  def list_income_by_user(user_uuid) do
    Repo.all(from i in Income, where: i.user_uuid == ^user_uuid, order_by: [desc: i.inserted_at])
  end

  def delete_income(id, user_uuid) do
    case get_income(id, user_uuid) do
      nil -> {:error, "Income not found"}
      income -> Repo.delete(income)
    end
  end
end
