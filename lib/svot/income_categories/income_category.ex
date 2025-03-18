defmodule Svot.IncomeCategory do
  use Svot.Schema
  import Ecto.Changeset
  alias Svot.Repo

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

  def changeset(%Svot.IncomeCategory{} = income_category, attrs \\ %{}) do
    income_category
    |> cast(attrs, [:income_uuid, :category_uuid])
    |> validate_required([:income_uuid, :category_uuid])
  end

  def bind(attrs) do
    %Svot.IncomeCategory{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
