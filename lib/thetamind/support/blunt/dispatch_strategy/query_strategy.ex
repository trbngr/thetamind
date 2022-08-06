defmodule Thetamind.Blunt.DispatchStrategy.QueryStrategy do
  import Blunt.DispatchStrategy
  import Ecto.Query, only: [from: 2]

  alias Blunt.Query
  alias Blunt.DispatchContext, as: Context
  alias Blunt.DispatchStrategy.PipelineResolver

  alias Thetamind.Blunt.QueryHandler

  def dispatch(%{message: filter_map} = context) do
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
end
