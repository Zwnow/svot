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
        <pre id="diagram" class="mermaid" phx-hook="Mermaid" phx-update="ignore">
          {diagram_test()}
        </pre>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def diagram_test() do
    "pie title Pets adopted by volunteers\n" <>
      Enum.map_join([dogs: 386, cats: 85], "\n", fn {title, value} -> 
        "\"#{title}\" : #{value}"
      end)
  end
end

