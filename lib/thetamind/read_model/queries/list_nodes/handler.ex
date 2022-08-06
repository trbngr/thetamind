defmodule Thetamind.ReadModel.Queries.ListNodes.Handler do
  use Thetamind.Blunt.QueryHandler

  alias Thetamind.{Repo, ReadModel.NodeModel}

  def create_query(filters, _context) do
    query = from n in NodeModel, as: :node

    Enum.reduce(filters, query, fn
      {:name_like, term}, query -> from [node: n] in query, where: ilike(n.name, ^"%#{term}%")
    end)
  end

  def handle_dispatch(query, _context, _opts) do
    Repo.all(query)
  end
end
