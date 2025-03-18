defmodule SvotWeb.IncomeDistributionLive do
  use SvotWeb, :live_view
  import Ecto.Query
  alias Svot.{Income, Incomes, IncomeCategory, Expense, Expenses, ExpenseCategory, Category, Categories}
  alias VegaLite, as: Vl

  def render(assigns) do
    IO.inspect(assigns.chart)
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
        <vega-lite data={@chart}></vega-lite>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    chart =
      Vl.new(width: 400, height: 300)
      |> Vl.mark(:bar)
      |> Vl.encode_field(:x, "month", type: :ordinal)
      |> Vl.encode_field(:y, "sales", type: :quantitative)
      |> Vl.data_from_values([
        %{month: "Jan", sales: 100},
        %{month: "Feb", sales: 150},
        %{month: "Mar", sales: 200}
      ])
      |> Vl.to_spec()

    {:ok, assign(socket, chart: Jason.encode!(chart))}
  end
end

