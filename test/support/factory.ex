defmodule Thetamind.Factory do
  defmacro __using__(_opts) do
    quote do
      use Thetamind.Testing.Factories, repo: Thetamind.Repo

      use Thetamind.Factory.Macros
      use Thetamind.Factory.TaskFactories
      use Thetamind.Factory.ReadModelFactories
    end
  end
end
