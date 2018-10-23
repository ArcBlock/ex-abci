defmodule SimpleChainTest do
  use ExUnit.Case
  doctest SimpleChain

  test "greets the world" do
    assert SimpleChain.hello() == :world
  end
end
