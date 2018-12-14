defmodule ExAbciTest.Fixture do
  @moduledoc false

  alias Types.{
    Header,
    Request,
    RequestBeginBlock,
    RequestCommit,
    RequestDeliverTx,
    RequestEndBlock,
    RequestFlush,
    RequestInfo,
    RequestInitChain
  }

  alias ExAbci.Varint

  def req_info(version \\ "version", block_version \\ 1) do
    data = RequestInfo.new(%{version: version, block_version: block_version})

    encode(:info, data)
  end

  def req_flush do
    encode(:flush, RequestFlush.new())
  end

  def req_init_chain(chain_id \\ "tyrchen") do
    data = RequestInitChain.new(%{chain_id: chain_id})
    encode(:init_chain, data)
  end

  def req_begin_block(hash, header) do
    header =
      Header.new(%{
        chain_id: header.chain_id,
        height: header.height,
        num_txs: header.num_txs,
        total_txs: header.total_txs
      })

    data = RequestBeginBlock.new(%{hash: Base.decode16!(hash, case: :lower), header: header})
    encode(:begin_block, data)
  end

  def req_deliver_tx(tx) do
    data = RequestDeliverTx.new(%{tx: tx})
    encode(:deliver_tx, data)
  end

  def req_end_block(height) do
    data = RequestEndBlock.new(%{height: height})
    encode(:end_block, data)
  end

  def req_commit() do
    data = RequestCommit.new()
    encode(:commit, data)
  end

  defp encode(type, data) do
    data =
      %{value: {type, data}}
      |> Request.new()
      |> Request.encode()

    size = data |> byte_size() |> Varint.encode_zigzag()
    size <> data
  end
end
