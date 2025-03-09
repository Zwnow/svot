defmodule Svot.Category do
  use Svot.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string

    belongs_to :user, Svot.User, foreign_key: :user_uuid, references: :uuid, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Category{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [:title, :user_uuid])
    |> validate_required([:title, :user_uuid])
  end
end
