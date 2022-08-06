defmodule Thetamind.Blunt.QueryHandler do
  @moduledoc false

  @type opts :: keyword()
  @type filters :: struct()
  @type filter_list :: keyword()
  @type user :: struct() | nil
  @type query :: Ecto.Query.t() | any()
  @type context :: Blunt.DispatchContext.t()

  @callback before_dispatch(filters(), context) :: {:ok, context()} | {:error, any()}
  @callback create_query(filter_list(), context()) :: query()
  @callback handle_dispatch(query(), context(), opts()) :: any()

  defmacro __using__(_opts) do
    quote do
      import Ecto.Query
      alias Thetamind.Repo

      @behaviour Thetamind.Blunt.QueryHandler

      @impl true
      def before_dispatch(_filters, context),
        do: {:ok, context}

      defoverridable before_dispatch: 2
    end
  end
end
