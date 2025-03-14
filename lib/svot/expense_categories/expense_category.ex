defmodule Svot.ExpenseCategory do
  alias Svot.Repo
  use Svot.Schema
  import Ecto.Changeset

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

  def changeset(%Svot.ExpenseCategory{} = expense_category, attrs \\ %{}) do
    expense_category
    |> cast(attrs, [:expense_uuid, :category_uuid])
    |> validate_required([:expense_uuid, :category_uuid])
  end

  def bind(attrs) do
    %Svot.ExpenseCategory{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
