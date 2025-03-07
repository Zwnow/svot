defmodule Svot.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string

    belongs_to :user, Svot.User

    timestamps(type: :utc_datetime)
  end

  def changeset(%Svot.Category{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
