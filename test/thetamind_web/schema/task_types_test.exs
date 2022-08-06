defmodule ThetamindWeb.Schema.TaskTypesTest do
  use ThetamindWeb.ConnCase

  describe "createNode" do
    @query """
      mutation createNode($name: String!){
        createNode(name: $name){
          id
          name
        }
      }
    """

    test "happy path", %{conn: conn} do
      name = Faker.Commerce.department()

      assert %{"id" => id, "name" => ^name} =
               conn
               |> post("/api", %{query: @query, variables: %{name: name}})
               |> json_response(200)
               |> get_in(["data", "createNode"])

      assert {:ok, _} = UUID.info(id)
    end
  end

  describe "listNodes connection" do
    @query """
      query nodes {
        listNodes(first: 5){
          pageInfo{
            hasNextPage
          }
          edges {
            node {
              id
            }
          }
        }
      }
    """

    test "works", %{conn: conn} do
      _ = insert_list(4, :node_model)

      assert %{
               "edges" => edges,
               "pageInfo" => %{"hasNextPage" => false}
             } =
               conn
               |> post("/api", %{query: @query})
               |> json_response(200)
               |> get_in(["data", "listNodes"])

      assert length(edges) == 4
    end
  end
end
