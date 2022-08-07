# defmodule Thetamind.Cqrs.DispatchStrategy.CommandStrategy do
#   # import Cqrs.DispatchStrategy

#   require Logger

#   alias Cqrs.DispatchContext, as: Context
#   alias Cqrs.DispatchStrategy.PipelineResolver

#   alias Thetamind.Cqrs.CommandHandler

#   def dispatch(%{message: command} = context) do
#     handler = PipelineResolver.get_pipeline!(context, CommandHandler)

#     with {:ok, context} <- execute({handler, :before_dispatch, [command, context]}, context),
#          {:ok, context} <- authorize_command(handler, context) do
#       execute_command(handler, context)
#     end
#   end

#   defp execute_command(handler, context) do
#     command = Context.get_message(context)

#     case Context.get_return(context) do
#       :command_context ->
#         {:ok, context}

#       :command ->
#         return_final(command, context)

#       _ ->
#         options = Context.options(context)

#         with {:ok, context} <- execute({handler, :handle_dispatch, [command, context, options]}, context) do
#           return_last_pipeline(context)
#         end
#     end
#   end

#   defp authorize_command(handler, %{message_type: :command} = context) do
#     if false == Context.get_option(context, :authorize?, false) do
#       {:ok, context}
#     else
#       case Context.user(context) do
#         nil ->
#           Logger.warn("Expected a user. But got nil")
#           {:error, "User not on context"}

#         user ->
#           do_handle_authorize(handler, user, context)
#       end
#     end
#   end

#   defp do_handle_authorize(handler, user, %{message: command} = context) do
#     auth = Context.get_metadata(context, :auth, [])
#     user_roles = Keyword.get(auth, :user_roles, [])
#     account_types = Keyword.get(auth, :account_types, [])

#     is_admin? = is_admin?(user)

#     with true <- is_admin? || user_in_role?(user, user_roles),
#          true <- is_admin? || account_in_type?(user, account_types) do
#       context = Context.put_user(context, Map.put(user, :is_admin?, is_admin?))

#       case apply(handler, :handle_authorize, [user, command, context]) do
#         {:ok, %Context{} = context} ->
#           {:ok, Context.put_pipeline(context, :handle_authorize, :ok)}

#         {:ok, _} ->
#           # TODO[epic=after blunt]: This can come out after the port. It probably doesn't need to error if we get back {:ok, _}
#           raise("#{inspect(context.message_module)} failed in handle_authorize because it didn't get a context back")

#         _ ->
#           {:error,
#            context
#            |> Context.put_pipeline(:handle_authorize, {:error, :unauthorized})
#            |> Context.put_error(:unauthorized)}
#       end
#     else
#       _ ->
#         {:error, Context.put_error(context, :unauthorized)}
#     end
#   end

#   defp is_admin?(%{is_admin?: true}), do: true
#   defp is_admin?(_), do: false

#   def user_in_role?(_user, []), do: false
#   def user_in_role?(_user, :all), do: true
#   def user_in_role?(_user, :none), do: false

#   def account_in_type?(_user, []), do: false
#   def account_in_type?(_user, :all), do: true
#   def account_in_type?(_user, :none), do: false
# end
