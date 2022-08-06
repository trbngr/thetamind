defmodule Thetamind.Tasks.Protocol.CreateNode do
  use Blunt.Command
  use Blunt.Command.EventDerivation

  use Thetamind.Blunt.Fields.PetFields

  internal_field :id, :binary_id

  field :name, :string
  field :pet_type, PetFields.pet_type(), required: false

  # Change this as needed for your needs. See dispatch_strategy in support/blunt
  metadata :auth,
    user_roles: :all,
    account_types: :all

  @impl true
  def after_validate(command) do
    %{command | id: UUID.uuid4()}
  end

  derive_event NodeCreated
end
