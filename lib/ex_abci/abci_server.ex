defmodule ExAbci.Server do
  @moduledoc """
  Default functions for handling the tendermint messages. If application didn't implement  these messages, default functions in this module will be used.
  """

  require Logger

  alias AbciVendor.{
    Header,
    RequestBeginBlock,
    RequestInitChain,
    ResponseBeginBlock,
    ResponseCommit,
    ResponseEndBlock,
    ResponseInitChain
  }

  def handle_init_chain(request) do
    %RequestInitChain{
      app_state_bytes: app_state,
      chain_id: chain_id,
      consensus_params: params,
      validators: validators
    } = request

    pub_keys = Enum.map(validators, fn v -> {v.pub_key.type, Base.encode16(v.pub_key.data)} end)

    Logger.debug(fn ->
      "Init chain: app_state: #{inspect(app_state)}, chain id: #{inspect(chain_id)}, consensus params: #{
        inspect(params)
      }, validators: #{inspect(pub_keys)}"
    end)

    ResponseInitChain.new(consensus_params: params, validators: validators)
  end

  def handle_begin_block(request) do
    %RequestBeginBlock{
      hash: _hash,
      header: %Header{
        app_hash: app_hash,
        consensus_hash: consensus_hash,
        data_hash: data_hash,
        evidence_hash: _evidence_hash,
        height: height,
        last_block_id: _last_block,
        last_commit_hash: _last_commit_hash,
        last_results_hash: _last_result_hash,
        next_validators_hash: _next_validators_hash,
        num_txs: num_txs,
        proposer_address: proposer_address,
        time: timestamp,
        total_txs: total_txs,
        validators_hash: _validators_hash
      },
      last_commit_info: _last_commit_info
    } = request

    Logger.debug(fn ->
      "Begin block: hash #{Base.encode16(app_hash)}, consensus_hash: #{
        Base.encode16(consensus_hash)
      }, data_hash: #{Base.encode16(data_hash)}, height: #{height}, num_txs: #{num_txs}, total_txs: #{
        total_txs
      }, proposer: #{Base.encode64(proposer_address)}, time: #{
        DateTime.from_unix!(timestamp.seconds)
      }"
    end)

    ResponseBeginBlock.new()
  end

  def handle_end_block(request) do
    Logger.debug(fn -> "End block: #{inspect(request)}" end)

    ResponseEndBlock.new(validator_updates: [])
  end

  def handle_commit(request) do
    Logger.debug(fn -> "Commit block: #{inspect(request)}" end)

    ResponseCommit.new(data: <<>>)
  end
end
