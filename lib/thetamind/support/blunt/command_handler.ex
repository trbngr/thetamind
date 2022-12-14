defmodule Thetamind.Blunt.CommandHandler do
  @moduledoc false

  @type user :: map()
  @type command :: struct()
  @type context :: Blunt.DispatchContext.command_context()
  @type opts :: keyword()

  @callback before_dispatch(command, context) :: {:ok, context()} | {:error, any()}
  @callback handle_authorize(user, command, context) :: {:ok, context()} | any()
  @callback handle_dispatch(command, context, opts) :: {:ok, context()} | {:error, context()} | any()

  defmacro __using__(_opts) do
    quote do
      @behaviour Thetamind.Blunt.CommandHandler

      @impl true
      def handle_authorize(_user, _command, context),
        do: {:ok, context}

      @impl true
      def before_dispatch(_command, context),
        do: {:ok, context}

      defoverridable handle_authorize: 3, before_dispatch: 2
    end
  end
end
