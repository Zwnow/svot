defmodule Svot.Categories do
  import Ecto.{Changeset, Query}
  alias Svot.{Category, ExpenseCategory, IncomeCategory, Repo}

  def create_category(attrs, user_id) do
    %Category{}
    |> Category.changeset(attrs)
    |> put_change(:user_id, user_id)
    |> Repo.insert()
  end

  def bind_expense_category(expense_id, category_id) do
    %ExpenseCategory{expense: expense_id, category: category_id}
    |> Repo.insert()
  end

  def bind_income_category(income_id, category_id) do
    %IncomeCategory{income: income_id, category: category_id}
    |> Repo.insert()
  end

  def get_category(id, user_id) do
    Repo.get_by(Category, id: id, user_id: user_id)
  end

  def update_category(id, user_id, attrs) do
    case get_category(id, user_id) do
      nil -> {:error, "Category not found"}
      category ->
        category
        |> Category.changeset(attrs)
        |> Repo.update()
    end
  end

  def list_user_categories(user_id) do
    Repo.all(from c in Category, where: c.user_id == ^user_id, order_by: [desc: c.inserted_at])
  end

  def delete_category(id, user_id) do
    case get_category(id, user_id) do
      nil -> {:error, "Category not found"}
      category -> Repo.delete(category)
    end
  end
end
