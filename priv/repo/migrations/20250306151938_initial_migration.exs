defmodule Svot.Repo.Migrations.InitialMigration do
  use Ecto.Migration

  def change do
    create table "users" do
      add :username, :string, null: false
      timestamps()
    end

    create table "categories" do
      add :title, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create table "expenses" do
      add :title, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :description, :text
      add :amount, :decimal, precision: 15, scale: 2, null: false
      add :interval, :string
      timestamps()
    end

    create table "expense_categories", primary_key: false do
      add :expense_id, references(:expenses, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false
    end

    create table "income" do
      add :title, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :description, :text
      add :amount, :decimal, precision: 15, scale: 2, null: false
      add :interval, :string

      timestamps()
    end

    create table "income_categories", primary_key: false do
      add :income_id, references(:income, on_delete: :delete_all), null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false
    end

    create unique_index(:users, [:username])

    create index(:expenses, [:user_id])
    create index(:income, [:user_id])
    create index(:categories, [:user_id])

    create index(:expense_categories, [:expense_id])
    create unique_index(:expense_categories, [:expense_id, :category_id])

    create index(:income_categories, [:income_id])
    create unique_index(:income_categories, [:income_id, :category_id])
  end
end
