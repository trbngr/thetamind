# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :blunt,
  dispatch_return: :response,
  error_return: :errors,
  log_when_compiling: false,
  create_jason_encoders: true,
  context_shipper: Thetamind.Blunt.ContextShipper,
  dispatch_strategy: Thetamind.Blunt.DispatchStrategy,
  pipeline_resolver: Thetamind.Blunt.PipelineResolver,
  schema_field_definitions: [
    Thetamind.Blunt.Fields.PetFields
  ],
  compiler_hooks: [
    command: [],
    query: [],
    domain_event: [
      {Thetamind.Blunt.CompilerHooks.DomainEvent, :create_commanded_json_decoder}
    ],
    value_object: [],
    entity: []
  ]

config :absinthe, schema: Thetamind.Schema
config :blunt_absinthe_relay, repo: Thetamind.Repo
config :blunt_absinthe, dispatch_context_configuration: Thetamind.Blunt.AbsintheContextConfiguration

config :thetamind, Thetamind.CommandedApp,
  registry: :local,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Thetamind.EventStore
  ]

config :thetamind, Thetamind.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime]

config :thetamind, Thetamind.EventStore,
  column_data_type: "jsonb",
  serializer: Commanded.Serialization.JsonSerializer,
  types: EventStore.PostgresTypes

config :thetamind,
  ecto_repos: [Thetamind.Repo],
  event_stores: [Thetamind.EventStore],
  generators: [binary_id: true]

# Configures the endpoint
config :thetamind, ThetamindWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ThetamindWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Thetamind.PubSub,
  live_view: [signing_salt: "5Dt2tdzJ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
