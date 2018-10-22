defmodule ExAbci.Server do
  @moduledoc """
  Server to handle abci messages
  """
  require Logger

  def handle_info(request) do
    Logger.info("Tendermint version: #{request.version}")

    %Abci.ResponseInfo{
      data: "Elixir counter app",
      version: "0.0.0",
      last_block_height: 0,
      last_block_app_hash: <<>>
    }
  end

  def handle_init_chain(request) do
    Logger.debug(fn -> "Init chain message: #{inspect(request)}" end)
    request
  end
end
