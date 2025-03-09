defmodule Svot.ExpensesTest do
  use ExUnit.Case
  use Svot.DataCase

  alias Svot.Expenses
  alias Svot.Users

  test "create_valid_expense" do
    attrs = %{
      title: "Test Expense", 
      description: "Some expense I made along the way",
      amount: 123.45,
      interval: "single"
    }

    user = create_test_user()

    assert {:ok, expense} = Expenses.create_expense(attrs, user.id)
    assert expense.amount == Decimal.new("123.45")
    assert expense.title == "Test Expense"
    assert expense.description == "Some expense I made along the way"
    assert expense.interval == :single
  end

  test "create_invalid_expense" do
    attrs = %{
      title: "Test Expense", 
      description: "Some expense I made along the way",
      amount: 0,
      interval: "single"
    }
    user = create_test_user()

    assert {:error, _} = Expenses.create_expense(attrs, user.id)
  end

  test "update_expense" do
    user = create_test_user()

    attrs = %{
      title: "Test Expense", 
      description: "Some expense I made along the way",
      amount: 123.45,
      interval: "single"
    }

    assert {:ok, expense} = Expenses.create_expense(attrs, user.id)

    new_expense = %{ id: expense.id, amount: 234.45 }

    assert {:ok, new_expense} = Expenses.update_expense(expense.id, user.id, new_expense)

    assert new_expense.amount == Decimal.new("234.45")
    assert new_expense.title == "Test Expense"
    assert new_expense.description == "Some expense I made along the way"
    assert new_expense.interval == :single

  end

  defp create_test_user() do
    user = %{username: "Zwnow"}
    {:ok, user} = Users.create_user(user)
    user
  end
end
