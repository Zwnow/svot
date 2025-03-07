defmodule Svot.Expenses do
  import Ecto.{Changeset, Query}
  alias Svot.{Expense, Repo}

  def create_expense(attrs, user_id) do
    %Expense{}
      |> Expense.changeset(attrs)
      |> put_change(:user_id, user_id)
      |> Repo.insert()
  end

  def get_expense(id, user_id) do
    Repo.get_by(Expense, id: id, user_id: user_id)
  end

  def update_expense(id, user_id, attrs) do
    case get_expense(id, user_id) do
      nil -> {:error, "Expense not found"}
      expense ->
        expense
        |> Expense.changeset(attrs)
        |> Repo.update()
    end
  end

  def list_user_expenses(user_id) do
    Repo.all(from e in Expense, where: e.user_id == ^user_id, order_by: [desc: e.inserted_at])
  end

  def delete_expense(id, user_id) do
    case get_expense(id, user_id) do
      nil -> {:error, "Expense not found"}
      expense -> Repo.delete(expense)
    end
  end
end
