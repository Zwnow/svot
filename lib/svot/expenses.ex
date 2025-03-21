defmodule Svot.Expenses do
  import Ecto.{Changeset, Query}
  alias Svot.{Expense, Repo}

  @spec create_expense(map(), String.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create_expense(attrs, user_uuid) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> put_change(:user_uuid, user_uuid)
    |> Repo.insert()
  end

  def get_expense(id, user_uuid) do
    Repo.get_by(Expense, uuid: id, user_uuid: user_uuid)
  end

  def update_expense(id, user_uuid, attrs) do
    case get_expense(id, user_uuid) do
      nil ->
        {:error, "Expense not found"}

      expense ->
        expense
        |> Expense.changeset(attrs)
        |> Repo.update()
    end
  end

  def list_user_expenses(user_uuid, page \\ 1, page_size \\ 20) do
    query =
      from e in Expense,
        where: e.user_uuid == ^user_uuid,
        order_by: [desc: e.inserted_at],
        limit: ^page_size,
        offset: ^((page - 1) * page_size)

    Repo.all(query)
  end

  def delete_expense(id, user_uuid) do
    case get_expense(id, user_uuid) do
      nil -> {:error, "Expense not found"}
      expense -> Repo.delete(expense)
    end
  end
end
