defmodule SvotWeb.UserProfileLive do
  use SvotWeb, :live_view

  #alias Svot.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Profile
    </.header>
    """
  end
end
