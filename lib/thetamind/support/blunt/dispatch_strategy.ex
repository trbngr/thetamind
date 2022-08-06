defmodule Thetamind.Blunt.DispatchStrategy do
  @behaviour Blunt.DispatchStrategy

  import Blunt.DispatchStrategy
  import Ecto.Query, only: [from: 2]

  require Logger

  alias Blunt.Query
  alias Blunt.DispatchContext, as: Context
  alias Blunt.DispatchStrategy.PipelineResolver

  alias Thetamind.Blunt.{CommandHandler, QueryHandler}

  @type context :: Context.t()
  @type query_context :: Context.query_context()
  @type command_context :: Context.command_context()

  @spec dispatch(command_context() | query_context()) ::
          {:error, context()} | {:ok, context() | any}

  @moduledoc """
  Receives a `DispatchContext`, locates the message handler, and runs the handler's pipeline.

  ## CommandHandler Pipeline

  1. `before_dispatch`
  2. `handle_dispatch`

  ## QueryHandler Pipeline

  1. `before_dispatch`
  2. `create_query`
  3. `handle_dispatch`
  """
  def dispatch(%{message_type: :command, message: command} = context) do
    handler = PipelineResolver.get_pipeline!(context, CommandHandler)
    context = put_user_id(context)

    with {:ok, context} <- execute({handler, :before_dispatch, [command, context]}, context) do
      execute_command(handler, context)
    end
  end

  def dispatch(%{message_type: :query, message: filter_map} = context) do
    bindings = Query.bindings(context)
    filter_list = Query.create_filter_list(context)
    handler = PipelineResolver.get_pipeline!(context, QueryHandler)

    context =
      context
      |> put_user_id()
      |> Context.put_private(:bindings, bindings)
      |> Context.put_private(:filters, Enum.into(filter_list, %{}))

    with {:ok, context} <- execute({handler, :before_dispatch, [filter_map, context]}, context),
         {:ok, context} <- execute({handler, :create_query, [filter_list, context]}, context) do
      execute_query(handler, context)
    end
  end

  defp put_user_id(%{user: nil} = context), do: context

  defp put_user_id(%{user: %{id: user_id}} = context),
    do: Context.put_private(context, :user_id, user_id)

  defp execute_query(handler, context) do
    preload = Query.preload(context)

    query = Context.get_last_pipeline(context)
    query = from(q in query, preload: ^preload)

    context = Context.put_private(context, :query, query)

    case Context.get_return(context) do
      :query_context ->
        {:ok, context}

      :query ->
        return_final(query, context)

      _ ->
        opts = Context.options(context)

        with {:ok, context} <-
               execute({handler, :handle_dispatch, [query, context, opts]}, context) do
          return_last_pipeline(context)
        end
    end
  end

  defp execute_command(handler, context) do
    command = Context.get_message(context)

    case Context.get_return(context) do
      :command_context ->
        {:ok, context}

      :command ->
        return_final(command, context)

      _ ->
        options = Context.options(context)

        with {:ok, context} <- execute({handler, :handle_dispatch, [command, context, options]}, context) do
          return_last_pipeline(context)
        end
    end
  end
end
