defmodule Svot.Expense do
  use Svot.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :title, :string
    field :description, :string
    field :amount, :decimal

    field :interval, Ecto.Enum,
      values: [:single, :daily, :weekly, :bi_weekly, :monthly, :quarterly, :halfyearly, :yearly]

    belongs_to :user, Svot.User, foreign_key: :user_uuid, references: :uuid, type: :binary_id
    has_many :category, Svot.ExpenseCategory

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Expense{} = expense, attrs \\ %{}) do
    expense
    |> cast(attrs, [:title, :description, :amount, :interval])
    |> validate_required([:title, :interval, :amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
