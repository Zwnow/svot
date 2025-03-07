defmodule Svot.Incomes do
  import Ecto.{Changeset, Query}
  alias Svot.{Income, Repo}

  def create_income(attrs, user_id) do
    %Income{}
    |> Income.changeset(attrs)
    |> put_change(:user_id, user_id)
    |> Repo.insert()
  end

  def get_income(id, user_id) do
    Repo.get_by(Income, id: id, user_id: user_id)
  end

  def update_income(id, user_id, attrs) do
    case get_income(id, user_id) do
      nil -> {:error, "Income not found"}
      income ->
        income
        |> Income.changeset(attrs)
        |> Repo.update()
    end
  end

  def list_income_by_user(user_id) do
    Repo.all(from i in Income, where: i.user_id == ^user_id, order_by: [desc: i.inserted_at])
  end

  def delete_income(id, user_id) do
    case get_income(id, user_id) do
      nil -> {:error, "Income not found"}
      income -> Repo.delete(income)
    end
  end
end
