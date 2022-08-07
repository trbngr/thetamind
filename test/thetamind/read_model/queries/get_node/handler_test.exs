defmodule Thetamind.ReadModel.Queries.GetNode.HandlerTest do
  use Thetamind.DataCase
  alias Thetamind.ReadModel.Queries.GetNode

  describe "query by id" do
    test "returns existing node" do
      %{id: id} = insert(:node_model)

      assert {:ok, %{id: ^id}} =
               %{id: id}
               |> GetNode.new()
               |> GetNode.execute()
    end

    test "returns nil if not found" do
      assert nil =
               %{id: UUID.uuid4()}
               |> GetNode.new()
               |> GetNode.execute()
    end
  end
end
