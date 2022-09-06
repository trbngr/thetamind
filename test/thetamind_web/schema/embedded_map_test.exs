defmodule ThetamindWeb.Schema.EmbeddedMapTest do
  use ThetamindWeb.ConnCase

  describe "createNodeWithIcon" do
    @query """
      mutation createNodeWithIcon($name: String!, $icon: IconInput!){
        createNodeWithIcon(name: $name, icon: $icon){
          id
          name
          icon {
            key
            value
          }
        }
      }
    """

    test "happy path", %{conn: conn} do
      name = Faker.Commerce.department()
      vars = %{name: name, icon: %{key: "emoji", value: "😂"}}

      assert %{"createNodeWithIcon" => %{"id" => id, "name" => ^name, "icon" => %{"key" => "emoji", "value" => "😂"}}} =
               conn
               |> post("/api", %{query: @query, variables: vars})
               |> json_response(200)
               |> get_in(["data"])

      assert {:ok, _} = UUID.info(id)
    end
  end
end
