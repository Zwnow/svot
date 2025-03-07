defmodule Svot.ExpenseCategory do
  use Ecto.Schema

  @primary_key false
  schema "expense_categories" do
    belongs_to :expense, Svot.Expense
    belongs_to :category, Svot.Category
  end
end
