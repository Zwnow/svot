defmodule Svot.Income do
  use Svot.Schema
  import Ecto.Changeset

  schema "income" do
    field :title, :string
    field :description, :string
    field :amount, :decimal
    field :interval, Ecto.Enum, values: [:single, :daily, :weekly, :bi_weekly, :monthly, :quarterly, :halfyearly, :yearly]

    belongs_to :user, Svot.User, foreign_key: :user_uuid, references: :uuid, type: :binary_id
    has_many :income, Svot.IncomeCategory

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Income{} = income, attrs \\ %{}) do
    income 
    |> cast(attrs, [:title, :user_uuid, :description, :amount, :interval])
    |> validate_required([:title, :user_uuid, :interval, :amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
