[
  import_deps: [
    :ecto,
    :ecto_sql,
    :commanded,
    :phoenix,
    :absinthe,
    :blunt,
    :blunt_data,
    :blunt_ddd,
    :blunt_absinthe,
    :blunt_absinthe_relay
  ],
  line_length: 120,
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
