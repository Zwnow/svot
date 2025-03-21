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
          phx-change="temp"
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
      |> assign(:income_diagram, "")
      |> assign(:datefilter, datefilter)
      |> then(fn socket -> 
        if connected?(socket) do
          socket
          |> assign_income_diagram(socket.assigns.datefilter)
        else
          socket
        end
      end)

    {:ok, socket}
  end

  def handle_event("temp", attrs, socket) do
    IO.inspect(attrs)

    {:noreply, socket}
  end

  def assign_income_diagram(socket, filter) do
    IO.inspect(filter)
    result = Incomes.sum_income(socket.assigns.current_user.uuid)

    diagram = "pie showData\n" <>
      Enum.map_join(result, "\n", fn {title, value} ->
        "\"#{title}\" : #{value}"
      end)

    assign(socket, :income_diagram, diagram)
  end

  def current_month_range do
    now = NaiveDateTime.local_now()

    {:ok, first_day} = NaiveDateTime.new(now.year, now.month, 1, 0, 0, 0)
    last_day_of_month = Date.days_in_month(%Date{year: now.year, month: now.month, day: 1})
    {:ok, last_day} = NaiveDateTime.new(now.year, now.month, last_day_of_month, 23, 59, 59)

    {first_day, last_day}
  end

  defp date_to_string(date) do
    if date == nil do
      ""
    else
      Date.to_string(date)
    end
  end
end

