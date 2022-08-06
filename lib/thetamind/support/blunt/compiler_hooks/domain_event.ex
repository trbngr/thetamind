defmodule Thetamind.Blunt.CompilerHooks.DomainEvent do
  @moduledoc false
  def create_commanded_json_decoder(%{module: module}) do
    quote do
      defimpl Commanded.Serialization.JsonDecoder, for: unquote(module) do
        def decode(data) do
          unquote(module).new(data)
        end
      end
    end
  end
end
