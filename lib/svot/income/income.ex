defmodule Svot.Income do
  use Svot.Schema
  import Ecto.Changeset
  alias Svot.Repo

  schema "income" do
    field :title, :string
    field :description, :string
    field :amount, :decimal

    field :interval, Ecto.Enum,
      values: [:single, :daily, :weekly, :bi_weekly, :monthly, :quarterly, :halfyearly, :yearly]

    belongs_to :user, Svot.Accounts.User,
      foreign_key: :user_uuid,
      references: :uuid,
      type: :binary_id

    has_many :category, Svot.IncomeCategory

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Income{} = income, attrs \\ %{}) do
    income
    |> Repo.preload(:category)
    |> cast(attrs, [:title, :description, :amount, :interval])
    |> validate_required([:title, :interval, :amount], message: "Pflichtfeld")
    |> validate_number(:amount, greater_than: 0, message: "Der Betrag muss größer als 0 sein")
  end
end
