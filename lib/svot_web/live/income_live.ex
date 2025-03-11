defmodule SvotWeb.IncomeLive do
  use SvotWeb, :live_view

  # alias Svot.Accounts

  def render(assigns) do
    ~H"""
    <div class="inset-0 absolute pt-8 pb-4 px-4 flex flex-col justify-start items-center w-full bg-gradient-to-b from-slate-100 to-slate-300">
      <.header class="text-center">
        Einkünfte
      </.header>
      <.back navigate={~p"/profile"}>
        Zurück
      </.back>
      <div class="flex flex-col gap-4 items-center p-2 w-full overflow-y-scroll h-[700px] sm:h-full bg-slate-100 shadow-2xl rounded-md">
      </div>
    </div>
    """
  end
end
