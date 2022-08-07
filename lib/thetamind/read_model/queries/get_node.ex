defmodule Thetamind.ReadModel.Queries.GetNode do
  use Cqrs.Query
  alias Thetamind.Repo
  alias Thetamind.ReadModel.NodeModel

  filter :id, :binary_id
  filter :name, :string

  # require_at_least_one([:id, :name])

  option :exists?, :boolean, default: false

  binding :node, Thetamind.ReadModel.NodeModel

  def handle_create(filters, _opts) do
    query = from n in NodeModel, as: :node

    Enum.reduce(filters, query, fn
      {:id, id}, query -> from [node: n] in query, where: n.id == ^id
      {:name, name}, query -> from [node: n] in query, where: n.name == ^name
    end)
  end

  def handle_execute(query, opts) do
    case Keyword.fetch!(opts, :exists?) do
      true -> Repo.exists?(query)
      false -> Repo.one(query)
    end
  end
end
