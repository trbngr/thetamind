[
  import_deps: [
    :ecto,
    :ecto_sql,
    :commanded,
    :phoenix,
    :absinthe,
    :blunt_data,
    :cqrs_tools
  ],
  line_length: 120,
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]
