defmodule Thetamind.ReadModel.Queries.GetNodeTest do
  use ExUnit.Case
  alias Thetamind.ReadModel.Queries.GetNode

  describe "filter validation" do
    test "at least one of :id or :name is required" do
      assert {:error,
              %{
                fields: ["expected at least one of following fields to be supplied: [:id, :name]"]
              }} = GetNode.new([])
    end

    test "passing just id is ok" do
      id = UUID.uuid4()
      assert {:ok, %{id: ^id}} = GetNode.new(id: id)
    end

    test "passing just name is ok" do
      assert {:ok, %{name: "chris"}} = GetNode.new(name: "chris")
    end
  end
end
