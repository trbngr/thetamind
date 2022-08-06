defmodule ThetamindWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias ThetamindWeb.Schema

  import_types Schema.TaskTypes

  query do
    import_fields :task_queries
  end

  mutation do
    import_fields :task_mutations
  end
end
