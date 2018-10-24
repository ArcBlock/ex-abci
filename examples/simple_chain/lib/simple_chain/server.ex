defmodule SimpleChain.Server do
  @moduledoc """
  Server to handle abci messages
  """
  use GenServer
  require Logger
  alias SimpleChain.{Account, AccountState, Mpt, Transaction, Tx}

  @msg_handler_prefix "handle_"
  @account_handler_prefix "account_"
  @chain_handler_prefix "chain_"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # This is the standard erlang method missing function to capture the undefined functions in a module. Here we just forward the function call to gen server handler since I don't want to repeat these public interfaces (might be a bad idea).
  def unquote(:"$handle_undefined_function")(func, args) do
    func_name = Atom.to_string(func)

    cond do
      String.starts_with?(func_name, @msg_handler_prefix) ->
        [request] = args
        GenServer.call(__MODULE__, {func, request})

      String.starts_with?(func_name, @account_handler_prefix) ->
        [addr] = args
        GenServer.call(__MODULE__, {func, addr})

      String.starts_with?(func_name, @chain_handler_prefix) ->
        GenServer.call(__MODULE__, {func, args})

      true ->
        nil
    end
  end

  # Callbacks

  def init(_) do
    dbpath = Application.get_env(:simple_chain, :db, "./states.db")

    {:ok, %{trie: Mpt.open(dbpath)}}
  end

  def handle_call({:account_balance, address}, _from, %{trie: trie} = state) do
    ret =
      case Account.get(trie, address) do
        nil -> 0
        %{balance: balance} -> balance
      end

    {:reply, ret, state}
  end

  def handle_call({:account_nonce, address}, _from, %{trie: trie} = state) do
    ret =
      case Account.get(trie, address) do
        nil -> 0
        %{nonce: nonce} -> nonce
      end

    {:reply, ret, state}
  end

  def handle_call({:account_info, address}, _from, %{trie: trie} = state) do
    {:reply, Account.get(trie, address), state}
  end

  def handle_call({:chain_info, []}, _from, %{trie: trie} = state) do
    {:reply, Mpt.get_info(trie), state}
  end

  def handle_call({:handle_info, request}, _from, %{trie: trie} = state) do
    last_block = Mpt.get_last_block(trie)
    app_hash = Mpt.get_app_hash(trie)

    Logger.info(
      "Tendermint version: #{request.version}, last_block: #{last_block}, app_hash: #{
        inspect(app_hash)
      }"
    )

    response = %Abci.ResponseInfo{
      data: "Elixir kv app",
      version: "1.0.0",
      last_block_height: String.to_integer(last_block),
      last_block_app_hash: app_hash
    }

    {:reply, response, state}
  end

  def handle_call({:handle_check_tx, request}, _from, %{trie: trie} = state) do
    %Abci.RequestCheckTx{tx: data} = request
    tx = data |> Base.decode64!() |> Transaction.decode()

    Logger.debug(fn -> "Check tx: #{inspect(tx)}" end)

    response = struct(Abci.ResponseCheckTx, verify(tx, trie, data))
    {:reply, response, state}
  end

  def handle_call({:handle_deliver_tx, request}, _from, %{trie: trie} = state) do
    %Abci.RequestDeliverTx{tx: data} = request
    tx = data |> Base.decode64!() |> Transaction.decode()

    Logger.debug(fn -> "Deliver tx: #{inspect(tx)}" end)

    response = struct(Abci.ResponseDeliverTx, verify(tx, trie, data))

    trie =
      case response.code == 0 do
        true -> update_state(tx, trie)
        _ -> trie
      end

    {:reply, response, %{state | trie: trie}}
  end

  def handle_call({:handle_end_block, request}, _from, %{trie: trie} = state) do
    Logger.debug(fn -> "End block: #{inspect(request)}" end)

    Mpt.update_block(trie, request.height)

    response = %Abci.ResponseEndBlock{
      validator_updates: [],
      tags: []
    }

    {:reply, response, state}
  end

  def handle_call({type, request}, _from, state) do
    # forward to default message handler
    response = apply(ExAbci.Server, type, [request])
    {:reply, response, state}
  end

  # private functions

  defp verify(tx, trie, data) do
    result =
      case Tx.verify(tx) do
        :ok -> verify_trie(tx, trie)
        _ -> false
      end

    case result do
      false ->
        %{
          code: 500,
          data: data,
          info: "tx not signed correctly or not match with current state",
          log: "failed to verify tx",
          gas_wanted: 0,
          gas_used: 0,
          tags: []
        }

      _ ->
        %{
          code: 0,
          data: data,
          info: "tx verified",
          log: "tx verified",
          gas_wanted: 0,
          gas_used: 0,
          tags: []
        }
    end
  end

  defp verify_trie(%Transaction{from: addr, to: <<>>, nonce: 0, total: 0}, trie) do
    case Account.get(trie, addr) |> IO.inspect() do
      nil -> true
      _data -> false
    end
  end

  defp verify_trie(%Transaction{from: addr, nonce: n1, total: total}, trie) do
    case Account.get(trie, addr) do
      %AccountState{nonce: n2, balance: balance} -> n1 === n2 and balance >= total
      _ -> false
    end
  end

  # for accounts declare itself, it would get 10000 tokens (this is just for bootstrapping purpose)
  defp update_state(%Transaction{from: addr, to: <<>>, nonce: 0, total: 0}, trie) do
    Account.put(trie, addr, %AccountState{nonce: 1, balance: 10000, num_txs: 1})
  end

  defp update_state(%Transaction{from: from, to: to, nonce: n1, total: total}, trie) do
    acc1 = Account.get(trie, from)

    trie =
      Account.put(trie, from, %AccountState{
        acc1
        | nonce: n1 + 1,
          balance: acc1.balance - total,
          num_txs: acc1.num_txs + 1
      })

    acc2 =
      case Account.get(trie, to) do
        nil -> %AccountState{nonce: 0, balance: total, num_txs: 1}
        v -> %AccountState{v | balance: v.balance + total, num_txs: v.num_txs + 1}
      end

    Account.put(trie, to, acc2)
  end
end
