# defmodule Thetamind.Cqrs.DispatchStrategy do
#   @behaviour Cqrs.DispatchStrategy

#   require Logger

#   alias Cqrs.DispatchContext, as: Context

#   @type context :: Context.t()
#   @type query_context :: Context.query_context()
#   @type command_context :: Context.command_context()

#   @spec dispatch(command_context() | query_context()) ::
#           {:error, context()} | {:ok, context() | any}

#   @moduledoc """
#   Receives a `DispatchContext`, locates the message handler, and runs the handler's pipeline.

#   ## CommandHandler Pipeline

#   1. `before_dispatch`
#   2. `handle_authorize`
#   3. `handle_dispatch`

#   ## QueryHandler Pipeline

#   1. `before_dispatch`
#   2. `create_query`
#   3. `handle_scope`
#   4. `handle_dispatch`
#   """
#   def dispatch(%{message_type: :command} = context) do
#     context
#     |> put_user_id()
#     |> __MODULE__.CommandStrategy.dispatch()
#   end

#   def dispatch(%{message_type: :query} = context) do
#     context
#     |> put_user_id()
#     |> __MODULE__.QueryStrategy.dispatch()
#   end

#   defp put_user_id(%{user: %{id: user_id}} = context),
#     do: Context.put_private(context, :user_id, user_id)

#   defp put_user_id(context), do: context
# end
