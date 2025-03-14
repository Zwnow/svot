defmodule SvotWeb.IncomeLive do
  use SvotWeb, :live_view
  import Ecto.Query
  alias Svot.{Income, Incomes, IncomeCategory, Category, Categories}

  def render(assigns) do
    ~H"""
    <div class="inset-0 absolute pt-8 pb-4 px-4 flex flex-col justify-start items-center w-full bg-gradient-to-b from-slate-100 to-slate-300">
      <.header class="text-center">
        Einkünfte
      </.header>
      <div class="flex w-full justify-start p-2">
        <.back navigate={~p"/profile"}>
          Zurück
        </.back>
      </div>
      <div class="flex flex-col gap-4 items-center p-2 w-full h-[700px] sm:h-full bg-slate-100 shadow-2xl rounded-md">
        <.update_income_modal {assigns} />
        <.create_income_modal {assigns} />

        <div class="flex flex-col gap-2 w-full overflow-y-scroll h-full">
          <%= if @income != [] do %>
            <%= for inc <- @income do %>
              <button
                phx-click="open_modal_update"
                phx-value-income={"#{inc.uuid}"}
                class="flex justify-between w-full p-2 rounded-md shadow-md"
              >
                <div class="flex flex-col justify-between items-start">
                  <h3 class="font-bold text-sm">{"#{inc.title}"}</h3>
                  <p class="text-sm">
                    {Calendar.strftime(NaiveDateTime.to_date(inc.inserted_at), "%d.%m.%Y")}
                  </p>
                </div>
                <p class="font-bold">
                  {"#{inc.amount} €"}
                </p>
              </button>
            <% end %>
          <% else %>
            <p>Noch keine Einkünfte erfasst.</p>
          <% end %>

          <div class="flex justify-center w-full gap-2">
            <button phx-click="prev_page" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Zurück
            </button>
            <button phx-click="next_page" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Weiter
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def create_income_modal(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center">
      <div class="flex flex-row gap-4 w-full justify-center items-center">
        <button
          phx-click="open_modal_income"
          class="rounded-md shadow-md bg-slate-700 p-2 text-white"
        >
          + Einkunft
        </button>
        <.create_category_modal {assigns} />
      </div>
      <.modal
        :if={@show_modal.income}
        id="create_income"
        show={@show_modal.income}
        on_cancel={JS.push("close_modal")}
      >
        <.form
          for={@income_form}
          id="create_income_form"
          phx-change="validate_income"
          method="post"
          phx-submit="save_income"
        >
          <.header class="text-center">
            Einkunft hinzufügen
          </.header>

          <.error :if={@check_errors.income}>
            Fehler beim Übertragen der Daten ...
          </.error>
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="text"
            label="Titel*"
            id="title"
            maxlength="25"
            field={@income_form[:title]}
            required
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            type="number"
            label="Betrag*"
            id="amount"
            step="0.01"
            field={@income_form[:amount]}
            placeholder="0.00 €"
            required
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            id="interval"
            label="Interval*"
            type="select"
            options={[
              Einzel: "single",
              Täglich: "daily",
              "Wöchentl.": "weekly",
              "Vierzehntägl.": "bi_weekly",
              "Monatl.": "monthly",
              "3-Monatl.": "quarterly",
              "6-Monatl.": "halfyearly",
              Jährlich: "yearly"
            ]}
            field={@income_form[:interval]}
          />
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="textarea"
            label="Beschreibung"
            id="description"
            field={@income_form[:description]}
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            id="categories"
            label="Kategorien"
            type="select"
            multiple={true}
            options={
              Enum.map(@categories, fn %Category{uuid: uuid, title: title} -> {title, uuid} end)
            }
            field={@income_form[:categories]}
          />
          <div class="flex flex-row p-4 gap-2 w-full justify-evenly items-center">
            <button
              phx-click="close_modal"
              type="button"
              class="rounded-md shadow-md bg-red-700 p-2 text-white"
            >
              Abbrechen
            </button>
            <button type="submit" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Speichern
            </button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

  def update_income_modal(assigns) do
    ~H"""
    <div class="flex flex-col z-[100] justify-center items-center">
      <.modal
        :if={@show_modal.update}
        id="update_income"
        show={@show_modal.update}
        on_cancel={JS.push("close_modal")}
      >
        <.form
          for={@update_form}
          id="update_income_form"
          phx-change="validate_income"
          method="post"
          phx-submit="update_income"
        >
          <.header class="text-center">
            Einkunft bearbeiten
          </.header>

          <.error :if={@check_errors.update}>
            Fehler beim Übertragen der Daten ...
          </.error>
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="text"
            label="Titel*"
            id="title"
            maxlength="25"
            field={@update_form[:title]}
            required
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            type="number"
            label="Betrag*"
            id="amount"
            step="0.01"
            field={@update_form[:amount]}
            placeholder="0.00 €"
            required
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            id="interval"
            label="Interval*"
            type="select"
            options={[
              Einzel: "single",
              Täglich: "daily",
              "Wöchentl.": "weekly",
              "Vierzehntägl.": "bi_weekly",
              "Monatl.": "monthly",
              "3-Monatl.": "quarterly",
              "6-Monatl.": "halfyearly",
              Jährlich: "yearly"
            ]}
            field={@update_form[:interval]}
          />
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="textarea"
            label="Beschreibung"
            id="description"
            field={@update_form[:description]}
          />
          <.input
            class="p-2 rounded-md border w-full border-slate-700"
            id="category"
            label="Kategorien"
            type="select"
            multiple={true}
            options={
              Enum.map(@categories, fn %Category{uuid: uuid, title: title} -> {title, uuid} end)
            }
            value={@update_form.data.categories}
            field={@update_form[:categories]}
          />
          <div class="flex flex-row p-4 gap-2 w-full justify-evenly items-center">
            <button
              phx-click="close_modal"
              type="button"
              class="rounded-md shadow-md bg-red-700 p-2 text-white"
            >
              Abbrechen
            </button>
            <button type="submit" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Speichern
            </button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

  def create_category_modal(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center z-[50]">
      <button
        phx-click="open_modal_category"
        type="button"
        class="rounded-md shadow-md bg-slate-700 p-2 text-white"
      >
        + Kategorie
      </button>
      <.modal
        :if={@show_modal.category}
        id="create_category"
        show={@show_modal.category}
        on_cancel={JS.push("close_modal")}
      >
        <.form
          for={@category_form}
          id="create_category_form"
          phx-change="validate_category"
          method="post"
          phx-submit="save_category"
        >
          <.header class="text-center">
            Kategorie hinzufügen
          </.header>

          <.error :if={@check_errors.category}>
            Die Kategorie existiert bereits!
          </.error>
          <.input
            class="p-2 rounded-md w-full border border-slate-700"
            type="text"
            label="Titel*"
            id="category_title"
            field={@category_form[:title]}
            required
          />
          <div class="flex flex-row p-4 gap-2 w-full justify-evenly items-center">
            <button
              phx-click="close_modal"
              type="button"
              class="rounded-md shadow-md bg-red-700 p-2 text-white"
            >
              Abbrechen
            </button>
            <button type="submit" class="rounded-md shadow-md bg-slate-700 p-2 text-white">
              Speichern
            </button>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    income_changeset =
      Income.changeset(%Income{})

    update_changeset =
      Income.changeset(%Income{})

    category_changeset =
      Category.changeset(%Category{})

    socket =
      socket
      |> assign(:income, [])
      |> assign(:categories, [])
      |> assign(:page, 1)
      |> assign(:check_errors, %{category: false, income: false, update: false})
      |> assign(:show_modal, %{category: false, income: false, update: false})
      |> assign_income_form(income_changeset)
      |> assign_category_form(category_changeset)
      |> assign_update_form(update_changeset)
      |> then(fn socket ->
        if connected?(socket) do
          socket
          |> assign_income()
          |> assign_categories()
        else
          socket
        end
      end)

    {:ok, socket}
  end

  def handle_event("open_modal_" <> name, params, socket) do
    case name do
      "category" ->
        {:noreply, assign(socket, show_modal: %{category: true, income: false, update: false})}

      "income" ->
        {:noreply, assign(socket, show_modal: %{category: false, income: true, update: false})}

      "update" ->
        uuid = Map.get(params, "income", "")
        if uuid != "" do
          income = Incomes.get_income(uuid, socket.assigns.current_user.uuid)
          update_changeset = Income.changeset(income)
          socket =
            socket
            |> assign_update_form(update_changeset)
            |> assign(update_uuid: income.uuid)
            |> assign(show_modal: %{category: false, income: false, update: true})
          {:noreply, socket}
        else
          {:noreply, socket}
        end

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: %{category: false, income: false, update: false})}
  end

  def handle_event("validate_income", %{"income" => attrs}, socket) do
    changeset = Income.changeset(%Income{}, attrs)
    {:noreply, assign_income_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("validate_income", %{"update" => attrs}, socket) do
    changeset = Income.changeset(%Income{}, attrs)
    {:noreply, assign_update_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("validate_category", %{"category" => attrs}, socket) do
    changeset = Category.changeset(%Category{}, attrs)
    {:noreply, assign_category_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save_category", %{"category" => attrs}, socket) do
    case Categories.create_category(attrs, socket.assigns.current_user.uuid) do
      {:ok, _} ->
        categories = Svot.Categories.list_user_categories(socket.assigns.current_user.uuid)
        changeset = Category.changeset(%Category{})

        socket =
          socket
          |> assign_category_form(changeset)

        {:noreply,
         assign(socket, categories: categories, show_modal: %{category: false, income: false, update: false})}

      {:error, _changeset} ->
        {:noreply, assign(socket, check_errors: %{category: true, income: false, update: false})}
    end
  end

  def handle_event("next_page", _, socket) do
    page = socket.assigns.page + 1
    income = Incomes.list_income_by_user(socket.assigns.current_user.uuid, page)

    socket =
      socket
      |> assign(:page, page)
      |> assign(:income, income)

    {:noreply, socket}
  end

  def handle_event("prev_page", _, socket) do
    page = socket.assigns.page - 1

    cond do
      page >= 1 ->
        income = Incomes.list_income_by_user(socket.assigns.current_user.uuid, page)

        socket =
          socket
          |> assign(:page, page)
          |> assign(:income, income)

        {:noreply, socket}

      true ->
        {:noreply, socket}
    end
  end

  def handle_event("update_income", %{"update" => attrs}, socket) do
    case Incomes.update_income(socket.assigns.update_uuid, socket.assigns.current_user.uuid, attrs) do
      {:ok, %Income{uuid: uuid}} ->
        categories = Map.get(attrs, "categories", [])

        if Enum.count(categories) > 0 do
          Svot.Repo.delete_all(from ic in IncomeCategory, where: ic.income_uuid == ^socket.assigns.update_uuid)
          Enum.each(categories, fn id ->
            IncomeCategory.bind(%{"category_uuid" => id, "income_uuid" => uuid})
          end)
        else
          Svot.Repo.delete_all(from ic in IncomeCategory, where: ic.income_uuid == ^socket.assigns.update_uuid)
        end

        income = Svot.Incomes.list_income_by_user(socket.assigns.current_user.uuid)
        changeset = Income.changeset(%Income{})

        socket =
          socket
          |> assign_income_form(changeset)

        {:noreply,
         assign(socket,
           income: income,
           show_modal: %{category: false, income: false, update: false}
         )}

      {:error, _changeset} ->
        {:noreply, assign(socket, check_errors: %{category: false, income: false, update: true})}
    end
  end

  def handle_event("save_income", %{"income" => attrs}, socket) do
    case Incomes.create_income(attrs, socket.assigns.current_user.uuid) do
      {:ok, %Income{uuid: uuid}} ->
        categories = Map.get(attrs, "categories", [])

        if Enum.count(categories) > 0 do
          Enum.each(categories, fn id ->
            IncomeCategory.bind(%{"category_uuid" => id, "income_uuid" => uuid})
          end)
        end

        income = Svot.Incomes.list_income_by_user(socket.assigns.current_user.uuid)
        changeset = Income.changeset(%Income{})

        socket =
          socket
          |> assign_income_form(changeset)

        {:noreply,
         assign(socket,
           income: income,
           show_modal: %{category: false, income: false, update: false}
         )}

      {:error, _changeset} ->
        {:noreply, assign(socket, check_errors: %{category: false, income: true, update: false})}
    end
  end

  defp assign_income_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "income")

    if changeset.valid? do
      assign(socket,
        income_form: form,
        check_errors: %{income: false, category: false, update: false}
      )
    else
      assign(socket, income_form: form)
    end
  end

  defp assign_update_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "update")
    
    new_data = Map.put(form.data, :categories, Enum.map(form.data.category, fn cat -> cat.category_uuid end))
    form = Map.put(form, :data, new_data)

    if changeset.valid? do
      assign(socket,
        update_form: form,
        check_errors: %{income: false, category: false, update: false}
      )
    else
      assign(socket, update_form: form)
    end
  end

  defp assign_category_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "category")

    if changeset.valid? do
      assign(socket,
        category_form: form,
        check_errors: %{income: false, category: false, update: false}
      )
    else
      assign(socket, category_form: form)
    end
  end

  defp assign_income(socket) do
    income = Svot.Incomes.list_income_by_user(socket.assigns.current_user.uuid)
    assign(socket, income: income)
  end

  defp assign_categories(socket) do
    categories = Svot.Categories.list_user_categories(socket.assigns.current_user.uuid)
    assign(socket, categories: categories)
  end
end
