defmodule Svot.IncomeTest do
  use ExUnit.Case
  use Svot.DataCase

  alias Svot.Incomes
  alias Svot.Users

  test "create_valid_income" do
    attrs = %{
      title: "Test Income", 
      description: "Some income I made along the way",
      amount: 123.45,
      interval: "single"
    }

    user = create_test_user()

    assert {:ok, income} = Incomes.create_income(attrs, user.uuid)
    assert income.amount == Decimal.new("123.45")
    assert income.title == "Test Income"
    assert income.description == "Some income I made along the way"
    assert income.interval == :single
  end

  test "create_invalid_income" do
    attrs = %{
      title: "Test Income", 
      description: "Some income I made along the way",
      amount: 0,
      interval: "single"
    }
    user = create_test_user()

    assert {:error, _} = Incomes.create_income(attrs, user.uuid)
  end

  test "update_income" do
    user = create_test_user()

    attrs = %{
      title: "Test Income", 
      description: "Some income I made along the way",
      amount: 123.45,
      interval: "single"
    }

    assert {:ok, income} = Incomes.create_income(attrs, user.uuid)

    new_income = %{ uuid: income.uuid, amount: 234.45 }

    assert {:ok, new_income} = Incomes.update_income(income.uuid, user.uuid, new_income)

    assert new_income.amount == Decimal.new("234.45")
    assert new_income.title == "Test Income"
    assert new_income.description == "Some income I made along the way"
    assert new_income.interval == :single

  end

  test "invalid_update_income" do
    user = create_test_user()

    attrs = %{
      title: "Test Income", 
      description: "Some income I made along the way",
      amount: 123.45,
      interval: "single"
    }

    assert {:ok, income} = Incomes.create_income(attrs, user.uuid)

    new_income = %{ uuid: income.uuid, amount: 0 }

    assert {:error, _} = Incomes.update_income(income.uuid, user.uuid, new_income)
  end

  defp create_test_user() do
    user = %{username: "Zwnow"}
    {:ok, user} = Users.create_user(user)
    user
  end
end
