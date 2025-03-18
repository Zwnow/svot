defmodule SvotWeb.UserProfileLive do
  use SvotWeb, :live_view

  # alias Svot.Accounts

  def render(assigns) do
    ~H"""
    <div class="inset-0 absolute pt-8 pb-4 px-4 flex flex-col justify-start items-center w-full bg-gradient-to-b from-slate-100 to-slate-300">
      <.header class="text-center">
        Profil
      </.header>
      <div class="flex flex-col gap-4 items-center p-2 w-full overflow-y-scroll h-[700px] sm:h-full bg-slate-100 shadow-2xl rounded-md">
        <.link
          navigate={~p"/expenses"}
          class="flex flex-row gap-2 justify-center items-center h-[100px] w-full rounded-md bg-white shadow-md"
        >
          <h3 class="text-lg font-bold">Ausgaben</h3>
          <.icon name="hero-arrow-right-start-on-rectangle" class="h-8 w-8" />
        </.link>
        <.link
          navigate={~p"/income"}
          class="flex flex-row gap-2 justify-center items-center h-[100px] w-full rounded-md bg-white shadow-md"
        >
          <h3 class="text-lg font-bold">Einkünfte</h3>
          <.icon name="hero-arrow-left-end-on-rectangle" class="h-8 w-8" />
        </.link>
        <.link
          navigate={~p"/income/distribution"}
          class="flex flex-row gap-2 justify-center items-center h-[100px] w-full rounded-md bg-white shadow-md"
        >
          <h3 class="text-lg font-bold">Einkommensverteilung</h3>
          <.icon name="hero-chart-bar" class="h-8 w-8 mb-2" />
        </.link>
      </div>
    </div>
    """
  end
end
