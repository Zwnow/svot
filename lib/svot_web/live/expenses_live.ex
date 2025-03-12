defmodule SvotWeb.ExpensesLive do
alias Svot.ExpenseCategory
  use SvotWeb, :live_view
  alias Svot.{Expense, Expenses, Category, Categories}

  def render(assigns) do
    ~H"""
    <div class="inset-0 absolute pt-8 pb-4 px-4 flex flex-col justify-start items-center w-full bg-gradient-to-b from-slate-100 to-slate-300">
      <.header class="text-center">
        Ausgaben
      </.header>
      <.back navigate={~p"/profile"}>
        Zurück
      </.back>
      <div class="flex flex-col gap-4 items-center p-2 w-full h-[700px] sm:h-full bg-slate-100 shadow-2xl rounded-md">
        <.create_expense_modal {assigns} />

        <div class="flex flex-col gap-2 overflow-y-scroll max-h-[500px] h-[500px]">
          <%= if @expenses != [] do %>
            <%= for {expense, index} <- Enum.with_index(@expenses) do %>
              <div>{"#{index + 1}. #{expense.title} #{expense.amount} €"}</div>
            <% end %>
          <% else %>
            <p>Noch keine Ausgaben erfasst.</p>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def create_expense_modal(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center">
      <div class="flex flex-row gap-4 w-full justify-center items-center">
        <button phx-click="open_modal" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
          + Ausgabe
        </button>
        <.create_category_modal {assigns} />
      </div>
      <.modal
        :if={@show_modal}
        id="create_expense"
        show={@show_modal}
        on_cancel={JS.push("close_modal")}
      >
        <.form
          for={@expense_form}
          id="create_expense_form"
          phx-change="validate"
          method="post"
          phx-submit="save_expense"
        >
          <.header class="text-center">
            Ausgabe hinzufügen
          </.header>

          <.error :if={@check_errors}>
            Fehler beim Übertragen der Daten ...
          </.error>
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="text"
            label="Titel*"
            id="title"
            field={@expense_form[:title]}
            required
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            type="number"
            label="Betrag*"
            id="amount"
            step="0.01"
            field={@expense_form[:amount]}
            placeholder="0.00 €"
            required
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            id="interval"
            label="Interval*"
            type="select"
            options={[
              "Einzel": "single",
              "Täglich": "daily",
              "Wöchentl.": "weekly",
              "Vierzehntägl.": "bi_weekly",
              "Monatl.": "monthly",
              "3-Monatl.": "quarterly",
              "6-Monatl.": "halfyearly",
              "Jährlich": "yearly"
            ]}
            field={@expense_form[:interval]}
          />
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="textarea"
            label="Beschreibung"
            id="description"
            field={@expense_form[:description]}
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            id="categories"
            label="Kategorien"
            type="select"
            multiple={true}
            options={Enum.map(@categories, fn %Category{uuid: uuid, title: title} -> {title, uuid} end)}
            field={@expense_form[:categories]}
          />
          <div class="flex flex-row p-4 gap-2 w-full justify-evenly items-center">
            <button
              phx-click="close_modal"
              type="button"
              class="rounded-md shadow-md bg-red-700 p-2 text-white"
            >
              Abbrechen
            </button>
            <button type="submit" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Speichern
            </button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

  def create_category_modal(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center z-[50]">
      <button phx-click="open_category_modal" type="button" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
        + Kategorie
      </button>
      <.modal
        :if={@show_category_modal}
        id="create_category"
        show={@show_category_modal}
        on_cancel={JS.push("close_category_modal")}
        >
        <.form
          for={@category_form}
          id="create_category_form"
          phx-change="validate_category"
          method="post"
          phx-submit="save_category"
          >
          <.header class="text-center">
            Kategorie hinzufügen
          </.header>

          <.error :if={@check_category_errors}>
            Die Kategorie existiert bereits!
          </.error>
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="text"
            label="Titel*"
            id="category_title"
            field={@category_form[:title]}
            required
          />
         <div class="flex flex-row p-4 gap-2 w-full justify-evenly items-center">
            <button
              phx-click="close_category_modal"
              type="button"
              class="rounded-md shadow-md bg-red-700 p-2 text-white"
              >
              Abbrechen
            </button>
            <button type="submit" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Speichern
            </button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    expense_changeset =
      Expense.changeset(%Expense{})

    category_changeset =
      Category.changeset(%Category{})

    socket =
      socket
      |> assign(:expenses, [])
      |> assign(:categories, [])
      |> assign(:check_errors, false)
      |> assign(:check_category_errors, false)
      |> assign(:show_modal, false)
      |> assign(:show_category_modal, false)
      |> assign_expense_form(expense_changeset)
      |> assign_category_form(category_changeset)
      |> then(fn socket ->
        if connected?(socket) do
          socket
          |> assign_expenses()
          |> assign_categories()
        else
          socket
        end
      end)

    {:ok, socket}
  end

  def handle_event("open_modal", _, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_event("open_category_modal", _, socket) do
    {:noreply, assign(socket, show_category_modal: true)}
  end

  def handle_event("close_category_modal", _, socket) do
    {:noreply, assign(socket, show_category_modal: false)}
  end

  def handle_event("validate", %{"expense" => attrs}, socket) do
    changeset = Expense.changeset(%Expense{}, attrs)
    {:noreply, assign_expense_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("validate_category", %{"category" => attrs}, socket) do
    changeset = Category.changeset(%Category{}, attrs)
    {:noreply, assign_category_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save_category", %{"category" => attrs}, socket) do
    case Categories.create_category(attrs, socket.assigns.current_user.uuid) do
      {:ok, _} ->
        categories = Svot.Categories.list_user_categories(socket.assigns.current_user.uuid)
        changeset = Category.changeset(%Category{})

        socket =
          socket
          |> assign_category_form(changeset)

        {:noreply, assign(socket, categories: categories, show_category_modal: false)}

      {:error, _changeset} ->
        {:noreply, assign(socket, check_category_errors: true)}
    end
  end

  def handle_event("save_expense", %{"expense" => attrs}, socket) do
    case Expenses.create_expense(attrs, socket.assigns.current_user.uuid) do
      {:ok, %Expense{uuid: uuid}} ->
        %{"categories" => categories} = attrs
        Enum.each(categories, fn id -> 
          ExpenseCategory.bind(%{"category_uuid" => id, "expense_uuid" => uuid})
        end)

        expenses = Svot.Expenses.list_user_expenses(socket.assigns.current_user.uuid)
        changeset = Expense.changeset(%Expense{})

        socket =
          socket
          |> assign_expense_form(changeset)

        {:noreply, assign(socket, expenses: expenses, show_modal: false)}

      {:error, _changeset} ->
        {:noreply, assign(socket, check_errors: true)}
    end
  end

  defp assign_expense_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "expense")

    if changeset.valid? do
      assign(socket, expense_form: form, check_errors: false)
    else
      assign(socket, expense_form: form)
    end
  end

  defp assign_category_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "category")

    if changeset.valid? do
      assign(socket, category_form: form, check_errors: false)
    else
      assign(socket, category_form: form)
    end
  end

  defp assign_expenses(socket) do
    expenses = Svot.Expenses.list_user_expenses(socket.assigns.current_user.uuid)
    assign(socket, expenses: expenses)
  end

  defp assign_categories(socket) do
    categories = Svot.Categories.list_user_categories(socket.assigns.current_user.uuid)
    assign(socket, categories: categories)
  end
end
