defmodule Thetamind.ReadModel.Queries.GetNode.Handler do
  use Thetamind.Blunt.QueryHandler

  alias Thetamind.{Repo, ReadModel.NodeModel}

  def create_query(filters, _context) do
    query = from n in NodeModel, as: :node

    Enum.reduce(filters, query, fn
      {:id, id}, query -> from [node: n] in query, where: n.id == ^id
      {:name, name}, query -> from [node: n] in query, where: n.name == ^name
    end)
  end

  def handle_dispatch(query, _context, opts) do
    case Keyword.fetch!(opts, :exists?) do
      true -> Repo.exists?(query)
      false -> Repo.one(query)
    end
  end
end
