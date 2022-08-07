# defmodule Thetamind.Cqrs.Commanded do
#   alias Thetamind.CommandedApp
#   # alias Cqrs.DispatchContext, as: Context
#   alias Commanded.Commands.ExecutionResult

#   def dispatch(%Context{message_type: :command, message: command} = context, metadata \\ %{}) when is_map(metadata) do
#     metadata = metadata_from_context(context)

#     case CommandedApp.dispatch(command, metadata: metadata) do
#       {:ok, %ExecutionResult{} = execution_result} ->
#         dispatch_response =
#           execution_result
#           |> Map.from_struct()
#           |> Map.drop([:metadata])

#         {:ok, Context.put_pipeline(context, :commanded, {:ok, dispatch_response})}

#       {:error, error} ->
#         {:error,
#          context
#          |> Context.put_error(error)
#          |> Context.put_pipeline(:commanded, {:error, error})}
#     end
#   end

#   def metadata_from_context(%{id: dispatch_id} = context) do
#     user = Map.get(context, :user, %{}) || %{}

#     options = Context.options_map(context)

#     context
#     |> Map.update!(:opts, &scrub_opts/1)
#     |> Map.update!(:message, &scrub_message/1)
#     |> Map.put(:current_user, scrub_user_metadata(user))
#     |> Map.put(:active_account_id, Map.get(user, :active_account_id))
#     |> Map.take([
#       :created_at,
#       :message,
#       :message_module,
#       :message_type,
#       :current_user,
#       :user_supplied_fields,
#       :active_account_id
#     ])
#     |> Map.merge(options)
#     |> Map.put(:dispatch_id, dispatch_id)
#     |> Map.put(:dispatched_at, DateTime.utc_now())
#   end

#   defp scrub_opts(opts) do
#     opts
#     |> Enum.into(%{})
#     |> Map.drop([:arg_types, :metadata])
#     |> Enum.map(fn
#       pid when is_pid(pid) -> to_string(pid)
#       struct when is_struct(struct) -> Map.from_struct(struct)
#       opt -> opt
#     end)
#   end

#   defp scrub_message(message) do
#     message
#     |> Map.from_struct()
#     |> Enum.into(%{}, fn
#       {field, %Ecto.Changeset{}} -> {field, :changeset}
#       other -> other
#     end)
#   end

#   defp scrub_user_metadata(nil), do: nil

#   defp scrub_user_metadata(user) do
#     Map.take(user, [
#       :id,
#       :name,
#       :email,
#       :is_admin?
#     ])
#   end
# end
