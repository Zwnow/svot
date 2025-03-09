defmodule Svot.CategoriesTest do
  use ExUnit.Case
  use Svot.DataCase

  alias Svot.{Categories, Expenses, Incomes, Users}

  test "create_category" do
    user = create_test_user()
    attrs = %{
      title: "Groceries"
    }

    assert {:ok, category} = Categories.create_category(attrs, user.uuid)
    assert category.title == "Groceries"
  end

  test "update_category" do
    user = create_test_user()
    attrs = %{
      title: "Groceries"
    }

    assert {:ok, category} = Categories.create_category(attrs, user.uuid)
    assert category.title == "Groceries"

    attrs = %{title: "Groceries 2"}
    assert {:ok, category} = Categories.update_category(category.uuid, user.uuid, attrs)
    assert category.title == "Groceries 2"
  end

  test "delete_category" do
    user = create_test_user()
    attrs = %{
      title: "Groceries"
    }

    assert {:ok, category} = Categories.create_category(attrs, user.uuid)
    assert category.title == "Groceries"
    assert {:ok, _} = Categories.delete_category(category.uuid, user.uuid)
  end

  test "delete_category_wrong_user" do
    user = create_test_user()
    attrs = %{
      title: "Groceries"
    }

    assert {:ok, category} = Categories.create_category(attrs, user.uuid)
    assert category.title == "Groceries"
    assert {:error, _} = Categories.delete_category(category.uuid, "b1ce3492-ad30-4b57-92ca-665066a7e3bd")
  end

  test "bind_expense_category" do
    user = create_test_user()
    attrs = %{
      title: "Groceries"
    }

    expense_attrs = %{
      title: "Test Expense", 
      description: "Some expense I made along the way",
      amount: 123.45,
      interval: "single"
    }
    assert {:ok, category} = Categories.create_category(attrs, user.uuid)
    assert {:ok, expense} = Expenses.create_expense(expense_attrs, user.uuid)
    assert {:ok, res} = Categories.bind_expense_category(expense.uuid, category.uuid)
    assert res.expense_uuid == expense.uuid
    assert res.category_uuid == category.uuid
  end

  test "bind_income_category" do
    user = create_test_user()
    attrs = %{
      title: "Wage"
    }

    expense_attrs = %{
      title: "Test Income", 
      description: "Some income I made along the way",
      amount: 1123.45,
      interval: "monthly"
    }
    assert {:ok, category} = Categories.create_category(attrs, user.uuid)
    assert {:ok, income} = Incomes.create_income(expense_attrs, user.uuid)
    assert {:ok, res} = Categories.bind_income_category(income.uuid, category.uuid)
    assert res.income_uuid == income.uuid
    assert res.category_uuid == category.uuid
  end

  defp create_test_user() do
    user = %{username: "Zwnow"}
    {:ok, user} = Users.create_user(user)
    user
  end
end
