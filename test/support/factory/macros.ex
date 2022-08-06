defmodule Thetamind.Factory.Macros do
  defmacro __using__(_opts) do
    quote do
      defmacrop new_uuid do
        quote do: &UUID.uuid4/0
      end

      defmacro start_process(module) do
        quote do: fn -> start_supervised(unquote(module)) end
      end

      defmacrop random_string(length: length) do
        quote do
          unquote(length)
          |> :crypto.strong_rand_bytes()
          |> Base.url_encode64()
          |> binary_part(0, unquote(length))
        end
      end
    end
  end
end
