defmodule Thetamind.Garden.BeanTest do
  use Thetamind.DataCase

  alias Thetamind.Garden

  @user_id UUID.uuid4()

  describe "flag bean" do
    test "succeeds when bean is leaf" do
      green_bean = create_bean(name: "Green")
      purple_bean = create_bean(name: "Purple", parent_id: green_bean.id)

      assert {:ok, bean} = Garden.flag_bean(%{id: purple_bean.id}, @user_id)

      assert bean.flagged
    end

    test "errors when bean has children" do
      green_bean = create_bean(name: "Green")
      _purple_bean = create_bean(name: "Purple", parent_id: green_bean.id)

      assert {:error, :bean_has_children} = Garden.flag_bean(%{id: green_bean.id}, @user_id)
    end

    test "succeeds when bean's children are flagged" do
      green_bean = create_bean(name: "Green")
      purple_bean = create_bean(name: "Purple", parent_id: green_bean.id)
      blue_bean = create_bean(name: "Blue", parent_id: purple_bean.id)

      assert {:ok, blue_bean} = Garden.flag_bean(%{id: blue_bean.id}, @user_id)
      assert {:ok, purple_bean} = Garden.flag_bean(%{id: purple_bean.id}, @user_id)
      assert {:ok, green_bean} = Garden.flag_bean(%{id: green_bean.id}, @user_id)

      assert blue_bean.flagged
      assert purple_bean.flagged
      assert green_bean.flagged
    end
  end

  def create_bean(attrs) do
    {:ok, bean} = Garden.create_bean(attrs, @user_id)
    bean
  end
end
