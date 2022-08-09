defmodule Thetamind.Tasks.Protocol.DeleteNode.HandlerTest do
  use Thetamind.DataCase
  alias Thetamind.Tasks.Protocol.DeleteNode

  describe "leaf field" do
    test "error if leaf doesn't exist" do
      assert {:error, "node not found"} =
               [id: UUID.uuid4()]
               |> DeleteNode.new()
               |> DeleteNode.dispatch()
    end

    test "ok if leaf exists" do
      %{id: id} = build(:leaf_env)

      assert {:ok, %{aggregate_state: %{id: nil}}} =
               [id: id]
               |> DeleteNode.new()
               |> DeleteNode.dispatch()
    end

    factory :leaf_env, debug: false do
      prop :node, &dispatch(:create_node, &1)
      prop :id, [:node, :id]
    end
  end
end
