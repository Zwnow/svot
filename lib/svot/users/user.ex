defmodule Svot.User do
  use Svot.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string

    has_many :expenses, Svot.Expense
    has_many :income, Svot.Income

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
