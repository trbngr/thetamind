# Take from blunt/lib/blunt/testing/factories.ex
if Code.ensure_loaded?(ExMachina) and Code.ensure_loaded?(Faker) do
  defmodule Blunt.Testing.Factories do
    defmacro __using__(opts) do
      repo = Keyword.get(opts, :repo)

      quote do
        use Blunt.Data.Factories, unquote(opts)
        use Blunt.Testing.Factories.DispatchStrategy

        if unquote(repo) do
          use ExMachina.Ecto, repo: unquote(repo)
        else
          use ExMachina
        end

        # builder Blunt.Testing.Factories.Builder.BluntMessageBuilder
        builder Thetamind.Factories.CqrsBuilder
      end
    end
  end
end
