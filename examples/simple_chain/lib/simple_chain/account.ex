defmodule SimpleChain.Account do
  @moduledoc """
  hanlde account state in MPT
  """
  alias SimpleChain.{AccountState, Mpt}

  def get(trie, addr) do
    case Mpt.get(trie, normalize(addr)) do
      nil -> nil
      data -> AccountState.decode(data)
    end
  end

  def put(trie, addr, data) do
    Mpt.put(trie, normalize(addr), AccountState.encode(data))
  end

  # private function
  defp normalize("0x" <> addr), do: String.downcase(addr)
end
