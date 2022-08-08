# Modifed from: blunt/lib/blunt/testing/factories/dispatch_strategy.ex
if Code.ensure_loaded?(ExMachina) and Code.ensure_loaded?(Faker) do
  defmodule Thetamind.Factories.CqrsDispatchStrategy do
    @moduledoc false
    use ExMachina.Strategy, function_name: :dispatch

    defmodule Error do
      defexception [:message]
    end

    # alias Cqrs.Metadata
    # alias Cqrs.Command

    def handle_dispatch(message, opts),
      do: handle_dispatch(message, opts, [])

    def handle_dispatch(%{__struct__: module} = message, opts, dispatch_opts) do
      # unless Message.dispatchable?(message) do
      #   raise Error, message: "#{inspect(module)} is not a dispatchable message"
      # end

      dispatch_opts =
        opts
        |> Keyword.new()
        |> Keyword.merge(dispatch_opts)
        |> Keyword.put(:dispatched_from, :ex_machina)
        |> Keyword.put(:returning, :aggregate_state)

      # |> Keyword.put(:user_supplied_fields, Metadata.field_names(module))

      # dbg()

      module.dispatch(message, dispatch_opts)

      # case module.dispatch({:ok, message}, dispatch_opts) do
      #   {:error, %DispatchContext{} = context} ->
      #     {:error, DispatchContext.errors(context)}

      #   {:error, errors} ->
      #     {:error, errors}

      #   {:ok, %DispatchContext{} = context} ->
      #     case DispatchContext.get_last_pipeline(context) do
      #       {:ok, result} -> {:ok, result}
      #       result -> {:ok, result}
      #     end

      #   other ->
      #     other
      # end
    end
  end
end