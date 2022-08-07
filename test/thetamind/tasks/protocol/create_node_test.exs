defmodule Thetamind.Tasks.Protocol.CreateNodeTest do
  use Thetamind.DataCase
  alias Thetamind.Tasks.Protocol.CreateNode

  describe "name" do
    test "is required" do
      assert {error, _} = build(:create_node, name: nil)
      assert %CreateNode{name: "Matt"} = build(:create_node, name: "Matt")
    end
  end

  # describe "pet type field" do
  #   test "can be one of the following values" do
  #     Enum.each([:dog, :lizard, :cat], fn pet_type ->
  #       assert %CreateNode{pet_type: ^pet_type} = build(:create_node, pet_type: pet_type)
  #     end)
  #   end

  #   test "other values are not valid" do
  #     assert {:error, %{pet_type: ["is invalid"]}} = build(:create_node, pet_type: :spider)
  #   end
  # end
end
