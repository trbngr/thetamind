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
  2. `handle_authorize`
  3. `handle_dispatch`

  ## QueryHandler Pipeline

  1. `before_dispatch`
  2. `create_query`
  3. `handle_scope`
  4. `handle_dispatch`
  """
  def dispatch(%{message_type: :command, message: command} = context) do
    handler = PipelineResolver.get_pipeline!(context, CommandHandler)
    context = put_user_id(context)

    with {:ok, context} <- execute({handler, :before_dispatch, [command, context]}, context),
         {:ok, context} <- authorize_command(handler, context) do
      execute_command(handler, context)
    end
  end

  def dispatch(%{message_type: :query, message: filter_map} = context) do
    bindings = Query.bindings(context)
    options = Context.options_map(context)
    filter_list = Query.create_filter_list(context)
    handler = PipelineResolver.get_pipeline!(context, QueryHandler)

    context =
      context
      |> Context.put_private(:bindings, bindings)
      |> Context.put_private(:filters, Enum.into(filter_list, %{}))

    with {:ok, context} <- execute({handler, :before_dispatch, [filter_map, context]}, context),
         {:ok, context} <- execute({handler, :create_query, [filter_list, context]}, context),
         {:ok, context} <- scope_query(handler, context, options) do
      execute_query(handler, context)
    end
  end

  # scope? is set to true in Thetamind.Blunt.AbsintheContextConfiguration
  defp scope_query(handler, context, %{scope?: true}) do
    import Ecto.Query, only: [where: 2]

    if Context.get_metadata(context, :disable_query_scoping, false) do
      {:ok, context}
    else
      query =
        case Context.get_last_pipeline(context) do
          %Ecto.Query{} = query ->
            case Context.user(context) do
              nil -> where(query, 1 == 0)
              user -> execute({handler, :handle_scope, [user, query, context]}, context)
            end

          query ->
            case Context.user(context) do
              nil -> query
              user -> execute({handler, :handle_scope, [user, query, context]}, context)
            end
        end

      case query do
        {:ok, %Context{} = context} -> {:ok, context}
        %Ecto.Query{} = query -> {:ok, Context.put_pipeline(context, :handle_scope, query)}
        other -> other
      end
    end
  end

  defp scope_query(_handler, context, _options), do: {:ok, context}

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

  defp authorize_command(handler, %{message_type: :command} = context) do
    if false == Context.get_option(context, :authorize?, false) do
      {:ok, context}
    else
      case Context.user(context) do
        nil ->
          Logger.warn("Expected a user. But got nil")
          {:error, "User not on context"}

        user ->
          do_handle_authorize(handler, user, context)
      end
    end
  end

  defp do_handle_authorize(handler, user, %{message: command} = context) do
    auth = Context.get_metadata(context, :auth, [])
    user_roles = Keyword.get(auth, :user_roles, [])
    account_types = Keyword.get(auth, :account_types, [])

    is_admin? = is_admin?(user)

    with true <- is_admin? || user_in_role?(user, user_roles),
         true <- is_admin? || account_in_type?(user, account_types) do
      context = Context.put_user(context, Map.put(user, :is_admin?, is_admin?))

      case apply(handler, :handle_authorize, [user, command, context]) do
        {:ok, %Context{} = context} ->
          {:ok, Context.put_pipeline(context, :handle_authorize, :ok)}

        {:ok, _} ->
          # TODO[epic=after blunt]: This can come out after the port. It probably doesn't need to error if we get back {:ok, _}
          raise("#{inspect(context.message_module)} failed in handle_authorize because it didn't get a context back")

        _ ->
          {:error,
           context
           |> Context.put_pipeline(:handle_authorize, {:error, :unauthorized})
           |> Context.put_error(:unauthorized)}
      end
    else
      _ ->
        {:error, Context.put_error(context, :unauthorized)}
    end
  end

  defp is_admin?(%{is_admin?: true}), do: true
  defp is_admin?(_), do: false

  def user_in_role?(_user, []), do: false
  def user_in_role?(_user, :all), do: true
  def user_in_role?(_user, :none), do: false

  def account_in_type?(_user, []), do: false
  def account_in_type?(_user, :all), do: true
  def account_in_type?(_user, :none), do: false
end
