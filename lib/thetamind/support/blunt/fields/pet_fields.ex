defmodule Thetamind.Blunt.Fields.PetFields do
  use Blunt.Message.Schema.FieldDefinition

  defmacro __using__(_opts) do
    quote do
      alias unquote(__MODULE__)
      import unquote(__MODULE__), only: :macros
    end
  end

  @pet_types [:dog, :lizard, :cat]

  def define(:pet_type, opts) do
    {:enum, Keyword.put(opts, :values, @pet_types)}
  end

  def all_pet_types, do: @pet_types

  defmacro pet_type do
    quote do: :pet_type
  end
end
