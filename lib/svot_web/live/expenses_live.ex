defmodule SvotWeb.ExpensesLive do
  use SvotWeb, :live_view
  alias Svot.{Expense}

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
        <div class="flex flex-col justify-center items-center">
          <button phx-click="open_modal" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
            + Ausgabe
          </button>
          <.modal
            :if={@show_modal}
            id="create_expense"
            show={@show_modal}
            on_cancel={JS.push("close_modal")}
          >
            <.simple_form 
              for={@expense_form}
              id="create_expense_form"
              phx-change="validate_create_expense"
              method="post"
              phx-submit="save_expense">
              <fieldset class="flex w-full flex-col">
                <label for="title">Titel</label>
                <.input
                  class="p-2 rounded-md w-full border border-slate-700"
                  type="text"
                  id="title"
                  name="title"
                  field={@expense_form[:title]}
                  required
                />
              </fieldset>
              <fieldset class="flex w-full flex-col">
                <label for="amount">Betrag</label>
                <.input
                  class="p-2 rounded-md border w-full border-slate-700"
                  type="number"
                  id="amount"
                  name="amount"
                  step="0.01"
                  field={@expense_form[:amount]}
                  placeholder="0.00 €"
                  required
                />
              </fieldset>
              <fieldset class="flex flex-col w-full">
                <label for="interval">Interval</label>
                <.input
                  class="p-2 rounded-md border w-full border-slate-700"
                  id="interval"
                  name="interval"
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
              </fieldset>
              <div class="flex flex-row p-4 gap-2 w-full justify-evenly items-center">
                <button
                  phx-click="close_modal"
                  type="button"
                  class="rounded-md shadow-md bg-red-700 p-2 text-white"
                >
                  Abbrechen
                </button>
                <button 
                  type="submit"
                  class="rounded-md shadow-md bg-slate-700 p-2 text-white">
                  Speichern
                </button>
              </div>
            </.simple_form>
          </.modal>
        </div>

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

  def mount(_params, _session, socket) do
    changeset = 
      Expense.changeset(%Expense{})


    socket =
      socket
      |> assign(:expenses, [])
      |> assign(:show_modal, false)
      |> assign_form(changeset)
      |> then(fn socket ->
        if connected?(socket) do
          expenses = Svot.Expenses.list_user_expenses(socket.assigns.current_user.uuid)
          assign(socket, expenses: expenses)
        else
          socket
        end
      end)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("open_modal", _, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_event("validate_create_expense", attrs, socket) do
    changeset = Expense.changeset(%Expense{}, attrs)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save_expense", attrs, socket) do
    Svot.Expenses.create_expense(attrs, socket.assigns.current_user.uuid);
    expenses = Svot.Expenses.list_user_expenses(socket.assigns.current_user.uuid)
    changeset = Expense.changeset(%Expense{})

    socket =
      socket
      |> assign_form(changeset)
    {:noreply, assign(socket, expenses: expenses, show_modal: false)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "expense")

    if changeset.valid? do
      assign(socket, expense_form: form, check_errors: false)
    else
      assign(socket, expense_form: form)
    end
  end
end
