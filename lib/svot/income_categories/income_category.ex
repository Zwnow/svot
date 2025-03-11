defmodule Svot.IncomeCategory do
  use Svot.Schema

  @primary_key false
  schema "income_categories" do
    belongs_to :income, Svot.Income,
      foreign_key: :income_uuid,
      references: :uuid,
      type: :binary_id

    belongs_to :category, Svot.Category,
      foreign_key: :category_uuid,
      references: :uuid,
      type: :binary_id
  end
end
