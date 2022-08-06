defmodule Thetamind.Factory.TaskFactories do
  alias Thetamind.Tasks.Protocol
  alias Thetamind.ReadModel.Queries

  defmacro __using__(_opts) do
    quote do
      factory Protocol.CreateNode, debug: false do
        lazy_prop :name, &Faker.Company.name/0
      end

      factory Protocol.NodeCreated, debug: false

      factory Protocol.DeleteNode, debug: false

      factory Queries.GetNode
    end
  end
end
