defmodule Thetamind.ReadModel.Queries.ListNodes do
  use Cqrs.Query

  # Just discovered that Relay connections will not work in Blunt without a field defined.
  filter :name_like, :string

  binding :node, Thetamind.ReadModel.NodeModel

  def handle_create(filters, _opts) do
    query = from n in NodeModel, as: :node

    Enum.reduce(filters, query, fn
      {:name_like, term}, query -> from [node: n] in query, where: ilike(n.name, ^"%#{term}%")
    end)
  end

  def handle_execute(query, _opts) do
    Repo.all(query)
  end
end
