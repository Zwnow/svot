defmodule SvotWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use SvotWeb, :html

  embed_templates "page_html/*"
end
