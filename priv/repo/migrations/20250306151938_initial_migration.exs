defmodule Svot.Repo.Migrations.InitialMigration do
  use Ecto.Migration
  # Setup
  # Postgres requires citext:
  
  # sudo -u postgres psql -d svot_test -c "CREATE EXTENSION citext;"
  # sudo -u postgres psql -d svot_dev -c "CREATE EXTENSION citext;"

  def change do
    create table(:users) do
      add :email, :citext, null: false
      add :username, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_uuid, references(:users, column: :uuid, type: :binary_id,  on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_uuid])
    create unique_index(:users_tokens, [:context, :token])

    create table "categories" do
      add :title, :string, null: false
      add :user_uuid, references(:users, column: :uuid, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end

    create table "expenses" do
      add :title, :string, null: false
      add :user_uuid, references(:users, column: :uuid, type: :binary_id,  on_delete: :delete_all), null: false
      add :description, :text
      add :amount, :decimal, precision: 15, scale: 2, null: false
      add :interval, :string
      timestamps()
    end

    create table "expense_categories", primary_key: false do
      add :expense_uuid, references(:expenses, column: :uuid, type: :binary_id, on_delete: :delete_all), null: false
      add :category_uuid, references(:categories, column: :uuid, type: :binary_id, on_delete: :delete_all), null: false
    end

    create table "income" do
      add :title, :string, null: false
      add :user_uuid, references(:users, column: :uuid, type: :binary_id, on_delete: :delete_all), null: false
      add :description, :text
      add :amount, :decimal, precision: 15, scale: 2, null: false
      add :interval, :string

      timestamps()
    end

    create table "income_categories", primary_key: false do
      add :income_uuid, references(:income, column: :uuid, type: :binary_id, on_delete: :delete_all), null: false
      add :category_uuid, references(:categories, column: :uuid, type: :binary_id, on_delete: :delete_all), null: false
    end

    create index(:expenses, [:user_uuid])
    create index(:income, [:user_uuid])
    create index(:categories, [:user_uuid])

    create index(:expense_categories, [:expense_uuid])
    create unique_index(:expense_categories, [:expense_uuid, :category_uuid])

    create index(:income_categories, [:income_uuid])
    create unique_index(:income_categories, [:income_uuid, :category_uuid])
  end
end
