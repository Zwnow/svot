defmodule Svot.Category do
  use Svot.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string

    belongs_to :user, Svot.Accounts.User,
      foreign_key: :user_uuid,
      references: :uuid,
      type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Category{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title, name: :unique_title_per_user)
  end
end
