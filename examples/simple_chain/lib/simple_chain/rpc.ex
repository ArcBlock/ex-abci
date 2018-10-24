defmodule SimpleChain.Rpc do
  @moduledoc """
  RPC lib to send tx. Using localhost:26657/broadcast_tx_commit?tx=<tx> for simplicity.
  """

  def send(tx) do
    url = "http://localhost:26657/broadcast_tx_commit?tx=\"#{Base.encode64(tx)}\""
    HTTPoison.get(url)
  end
end
