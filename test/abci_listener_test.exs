defmodule ExAbciTest.Listener do
  @moduledoc false
  use ExUnit.Case
  alias ExAbci.Listener
  alias ExAbciTest.Fixture

  alias Types.Request

  test "shall decode messages" do
    messages = [
      %{
        data: Fixture.req_info("0.26.0-c086d0a3"),
        type: :info,
        assert_fn: fn data -> assert data.version === "0.26.0-c086d0a3" end
      },
      %{
        data: Fixture.req_flush(),
        type: :flush
      },
      %{
        data: Fixture.req_init_chain("tyrchen"),
        type: :init_chain,
        assert_fn: fn data ->
          assert data.chain_id === "tyrchen"
          assert data.app_state_bytes === ""
        end
      },
      %{
        data:
          Fixture.req_begin_block("ed339e607a5640680e38600c008636a345e177a4", %{
            chain_id: "tyrchen",
            height: 5,
            num_txs: 1,
            total_txs: 4
          }),
        type: :begin_block,
        assert_fn: fn data ->
          assert data.hash ===
                   Base.decode16!("ed339e607a5640680e38600c008636a345e177a4", case: :lower)

          assert data.header.chain_id === "tyrchen"
          assert data.header.height === 5
          assert data.header.num_txs === 1
          assert data.header.total_txs === 4
        end
      },
      %{
        data: Fixture.req_deliver_tx("hello world"),
        type: :deliver_tx,
        assert_fn: fn data -> assert data.tx === "hello world" end
      },
      %{
        data: Fixture.req_end_block(5),
        type: :end_block,
        assert_fn: fn data -> assert data.height === 5 end
      },
      %{
        data: Fixture.req_commit(),
        type: :commit
      }
    ]

    Enum.map(messages, fn %{data: data, type: type} = msg ->
      {[request], ""} = Listener.unpack_requests(data)
      assert %Request{value: {^type, req}} = request

      case Map.get(msg, :assert_fn, nil) do
        nil -> :ok
        assert_fn -> assert_fn.(req)
      end
    end)
  end
end
