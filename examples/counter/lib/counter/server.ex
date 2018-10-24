defmodule Counter.Server do
  @moduledoc """
  Server to handle abci messages
  """
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # This is the standard erlang method missing function to capture the undefined functions in a module. Here we just forward the function call to gen server handler since I don't want to repeat these public interfaces (might be a bad idea).
  def unquote(:"$handle_undefined_function")(func, [request]) do
    func_name = Atom.to_string(func)

    case String.starts_with?(func_name, "handle_") do
      true -> GenServer.call(__MODULE__, {func, request})
      _ -> nil
    end
  end

  # Callbacks

  def init(_) do
    {:ok, %{counter: 0}}
  end

  def handle_call({:handle_info, request}, _from, state) do
    Logger.info("Tendermint version: #{request.version}")

    response = %Abci.ResponseInfo{
      data: "Elixir counter app",
      version: "1.0.0",
      last_block_height: state.counter,
      last_block_app_hash: <<>>
    }

    {:reply, response, state}
  end

  def handle_call({:handle_check_tx, request}, _from, %{counter: counter} = state) do
    %Abci.RequestCheckTx{tx: tx} = request
    Logger.debug(fn -> "Check tx: #{inspect(tx)}" end)

    response = struct(Abci.ResponseCheckTx, check_tx(tx, counter))
    {:reply, response, state}
  end

  def handle_call({:handle_deliver_tx, request}, _from, %{counter: counter} = state) do
    %Abci.RequestDeliverTx{tx: tx} = request
    Logger.debug(fn -> "Deliver tx: #{inspect(tx)}" end)

    response = struct(Abci.ResponseDeliverTx, check_tx(tx, counter))

    {:reply, response, %{state | counter: counter + 1}}
  end

  def handle_call({type, request}, _from, state) do
    # forward to default message handler
    response = apply(ExAbci.Server, type, [request])
    {:reply, response, state}
  end

  # private functions
  def check_tx(tx, counter) do
    v = String.to_integer(tx)

    case v == counter do
      false ->
        %{
          code: 500,
          data: tx,
          info: "tx doesn't match with current counter",
          log: "failed to parse tx or tx doesn't match with current counter",
          gas_wanted: 0,
          gas_used: 0,
          tags: []
        }

      _ ->
        %{
          code: 0,
          data: tx,
          info: "tx verified",
          log: "tx verified",
          gas_wanted: 0,
          gas_used: 0,
          tags: []
        }
    end
  rescue
    _ ->
      %{
        code: 500,
        data: tx,
        info: "failed to parse tx",
        log: "failed to parse tx or tx doesn't match with current counter",
        gas_wanted: 0,
        gas_used: 0,
        tags: []
      }
  end
end
