defmodule LolHero.Web do
  def controller do
    quote do
      use Phoenix.Controller

      alias LolHero.Repo

      import Ecto
      import Ecto.Query

      import LolHero.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import LolHero.Router.Helpers
    end
  end

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
      import Ecto.Multi

      @timestamps_opts [type: :utc_datetime]
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
