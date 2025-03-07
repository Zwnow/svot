defmodule Svot.Income do
  use Ecto.Schema
  import Ecto.Changeset

  schema "income" do
    field :title, :string
    field :description, :string
    field :amount, :decimal
    field :interval, Ecto.Enum, values: [:single, :daily, :weekly, :bi_weekly, :monthly, :quarterly, :halfyearly, :yearly]

    belongs_to :user, Svot.User

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Income{} = income, attrs \\ %{}) do
    income 
    |> cast(attrs, [:title, :user_id, :description, :amount, :interval])
    |> validate_required([:title, :user_id, :interval, :amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
