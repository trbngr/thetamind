defmodule Thetamind.Factories.CqrsBuilder do
  @moduledoc false
  @behaviour Blunt.Data.Factories.Builder

  defmodule Error do
    defexception [:errors]

    def message(%{errors: errors}) do
      inspect(errors)
    end
  end

  @impl true
  def recognizes?(mod) do
    function_exported?(mod, :__command__, 0)
  end

  @impl true
  def message_fields(command) do
    command.__fields__
  end

  @impl true
  def field_validations(_message_module) do
    []
  end

  @impl true
  def build(message_module, data) do
    case message_module.new(data) do
      {:ok, message} ->
        message

      other ->
        other
    end
  end

  @impl true
  def dispatch({:error, _} = message), do: message

  @impl true
  def dispatch(%{__struct__: module} = message) do
    case module.dispatch({:ok, message, %{}}, return: :response) do
      {:ok, value} -> value
      {:error, errors} -> {:error, %Error{errors: errors}}
    end
  end
end

# defmodule Blunt.Testing.Factories.Builder.BluntMessageBuilder do
#   @moduledoc false
#   @behaviour Blunt.Data.Factories.Builder

#   defmodule Error do
#     defexception [:errors]

#     def message(%{errors: errors}) do
#       inspect(errors)
#     end
#   end

#   alias Blunt.Message.Metadata
#   alias Blunt.{Behaviour, Message}

#   @impl true
#   def recognizes?(message_module) do
#     Behaviour.is_valid?(message_module, Message)
#   end

#   @impl true
#   def message_fields(message_module),
#     do: Metadata.fields(message_module)

#   @impl true
#   def field_validations(message_module),
#     do: Metadata.field_validations(message_module)

#   @impl true
#   def build(message_module, data) do
#     case message_module.new(data) do
#       {:ok, message} ->
#         message

#       other ->
#         other
#     end
#   end

#   @impl true
#   def dispatch({:error, _} = message), do: message

#   @impl true
#   def dispatch(%{__struct__: module} = message) do
#     unless Message.dispatchable?(message) do
#       message
#     else
#       case module.dispatch({:ok, message, %{}}, return: :response) do
#         {:ok, value} -> value
#         {:error, errors} -> {:error, %Error{errors: errors}}
#       end
#     end
#   end
# end
