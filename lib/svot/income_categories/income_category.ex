defmodule Svot.IncomeCategory do
  use Ecto.Schema

  @primary_key false
  schema "income_categories" do
    belongs_to :income, Svot.Income
    belongs_to :category, Svot.Category
  end
end
