defmodule SvotWeb.IncomeDistributionLive do
  use SvotWeb, :live_view
  import Ecto.Query
  alias Svot.{Income, Incomes, IncomeCategory, Expense, Expenses, ExpenseCategory, Category, Categories}

  def render(assigns) do
    ~H"""
    <div class="inset-0 absolute pt-8 pb-4 px-4 flex flex-col justify-start items-center w-full bg-gradient-to-b from-slate-100 to-slate-300">
      <.header class="text-center">
        Einkommensverteilung
      </.header>
      <div class="flex w-full justify-start p-2">
        <.back navigate={~p"/profile"}>
          Zurück
        </.back>
      </div>

      <div class="flex flex-col gap-4 items-center p-2 w-full h-[700px] sm:h-full bg-slate-100 shadow-2xl rounded-md">
        <.form
          for={@datefilter}
          phx-change="update_datefilter"
          class="flex flex-col gap-2"
          >
          <div
            class="flex flex-row gap-2"
            >
            <.input
            type="date"
            name="from"
            value={@datefilter["from"]}
            />
            <.input
            type="date"
            name="to"
            value={@datefilter["to"]}
            />
          </div>
          <button
            phx-click="update_diagram"
            type="button">
            Update
          </button>
        </.form>

        <pre id="diagram" class="mermaid" phx-hook="Mermaid">
          {@income_diagram}
        </pre>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {first_day, last_day} = current_month_range()
    datefilter = %{"from" => NaiveDateTime.to_date(first_day), "to" => NaiveDateTime.to_date(last_day)}

    socket = 
      socket
      |> assign(:datefilter, datefilter)
      |> assign_income_diagram(datefilter)
    {:ok, socket}
  end

  def handle_event("update_diagram", attrs, socket) do
    socket =
      socket
      |> assign_income_diagram(socket.assigns.datefilter)

    {:noreply, socket}
  end

  def handle_event("update_datefilter", attrs, socket) do
    {:ok, from_date} = Date.from_iso8601(attrs["from"])
    {:ok, to_date} = Date.from_iso8601(attrs["to"])

    datefilter = %{"from" => from_date, "to" => to_date}

    {:noreply, assign(socket, :datefilter, datefilter)}
  end

  def assign_income_diagram(socket, filter) do
    result = Incomes.sum_income(socket.assigns.current_user.uuid, filter)

    diagram = "pie showData\n" <>
      Enum.map_join(result, "\n", fn {title, value} ->
        "\"#{title}\" : #{value}"
      end)

    config = """
      ---
      config:
        look: handDrawn
        theme: neutral
      ---
      """

    assign(socket, :income_diagram, config <> diagram)
  end

  def current_month_range do
    now = NaiveDateTime.local_now()

    {:ok, first_day} = NaiveDateTime.new(now.year, now.month, 1, 0, 0, 0)
    last_day_of_month = Date.days_in_month(%Date{year: now.year, month: now.month, day: 1})
    {:ok, last_day} = NaiveDateTime.new(now.year, now.month, last_day_of_month, 23, 59, 59)

    {first_day, last_day}
  end
end

