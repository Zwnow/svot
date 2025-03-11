defmodule SvotWeb.ExpensesLive do
  use SvotWeb, :live_view

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
            <form phx-submit="save_expense">
              <fieldset class="flex w-full flex-col">
                <label for="title">Titel</label>
                <input
                  class="p-2 rounded-md w-full border border-slate-700"
                  type="text"
                  id="title"
                  name="title"
                  required
                />
              </fieldset>
              <fieldset class="flex w-full flex-col">
                <label for="amount">Betrag</label>
                <input
                  class="p-2 rounded-md border w-full border-slate-700"
                  type="number"
                  id="amount"
                  name="amount"
                  step="0.01"
                  placeholder="0.00 €"
                  required
                />
              </fieldset>
              <fieldset class="flex flex-col w-full">
                <label for="interval">Interval</label>
                <select
                  class="p-2 rounded-md border w-full border-slate-700"
                  id="interval"
                  name="interval"
                >
                  <option value="single" selected>Einzel</option>
                  <option value="daily">Täglich</option>
                  <option value="weekly">Wöchentl.</option>
                  <option value="bi_weekly">Vierzehntägl.</option>
                  <option value="monthly">Monatl.</option>
                  <option value="quarterly">3-Monatl.</option>
                  <option value="halfyearly">6-Monatl.</option>
                  <option value="yearly">Jährlich</option>
                </select>
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
            </form>
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
    socket =
      socket
      |> assign(:expenses, [])
      |> assign(:show_modal, false)
      |> then(fn socket ->
        if connected?(socket) do
          expenses = Svot.Expenses.list_user_expenses(socket.assigns.current_user.uuid)
          assign(socket, expenses: expenses)
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

  def handle_event("save_expense", attrs, socket) do
    Svot.Expenses.create_expense(attrs, socket.assigns.current_user.uuid);
    expenses = Svot.Expenses.list_user_expenses(socket.assigns.current_user.uuid)
    {:noreply, assign(socket, expenses: expenses, show_modal: false)}
  end
end
