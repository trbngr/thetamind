defmodule Thetamind.Blunt.CommandHandler do
  @moduledoc false

  @type user :: map()
  @type command :: struct()
  @type context :: Blunt.DispatchContext.command_context()
  @type opts :: keyword()

  @callback before_dispatch(command, context) :: {:ok, context()} | {:error, any()}
  @callback handle_dispatch(command, context, opts) ::
              {:ok, context()} | {:error, context()} | any()

  defmacro __using__(_opts) do
    quote do
      @behaviour Thetamind.Blunt.CommandHandler

      alias Blunt.DispatchContext

      @impl true
      def before_dispatch(_command, context),
        do: {:ok, context}

      defoverridable before_dispatch: 2
    end
  end
end
