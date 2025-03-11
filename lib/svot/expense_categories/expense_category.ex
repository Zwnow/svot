defmodule Svot.ExpenseCategory do
  use Svot.Schema

  @primary_key false
  schema "expense_categories" do
    belongs_to :expense, Svot.Expense,
      foreign_key: :expense_uuid,
      references: :uuid,
      type: :binary_id

    belongs_to :category, Svot.Category,
      foreign_key: :category_uuid,
      references: :uuid,
      type: :binary_id
  end
end
