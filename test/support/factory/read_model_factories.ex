defmodule Thetamind.Factory.ReadModelFactories do
  alias Thetamind.ReadModel

  defmacro __using__(_opts) do
    quote do
      factory ReadModel.NodeModel, debug: false do
        lazy_prop :id, new_uuid()
        lazy_prop :name, &Faker.Company.name/0
      end
    end
  end
end
