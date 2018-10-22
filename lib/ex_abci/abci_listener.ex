# defmodule ExAbci.ListenerState do
#   require Record
#   Record.defrecord(:state, socket: nil, transport: :gen_tcp, buffered: <<>>, mod: nil)

#   @type state ::
#           record(:state, socket: socket(), transport: atom(), buffered: binary(), mod: module())
#   # expands to: "@type user :: {:user, String.t, integer}"
# end

defmodule ExAbci.Listener do
  @moduledoc """
  Gen Server for ABCI interface, using ranch
  """
  use GenServer
  import Bitwise
  require Logger

  alias Abci.{Request, Response}

  @behaviour :ranch_protocol

  @spec start_link(reference(), any(), atom(), list()) :: {:ok, pid} | {:error, any()}
  def start_link(ref, socket, transport, opts) do
    {:ok, :proc_lib.spawn_link(__MODULE__, :init, [{ref, socket, transport, opts}])}
  end

  @spec gen_ranch_args(module(), pos_integer()) :: term()
  def gen_ranch_args(mod, port),
    do: [mod, 3, :ranch_tcp, [port: port, max_connections: 3], ExAbci.Listener, [mod]]

  @spec start_listener(module(), pos_integer()) :: :supervisor.startchild_ret()
  def start_listener(mod, port), do: apply(:ranch, :start_listener, gen_ranch_args(mod, port))

  @spec start_listener(module(), pos_integer()) :: :supervisor.child_spec()
  def child_spec(mod, port), do: apply(:ranch, :child_spec, gen_ranch_args(mod, port))

  @spec stop_listener(module()) :: :ok | {:error, any()}
  def stop_listener(mod), do: :ranch.stop_listener(mod)

  # GenServer callbacks
  def init({ref, socket, transport, [mod]}) do
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, active: :once)

    :gen_server.enter_loop(__MODULE__, [], %{
      socket: socket,
      transport: transport,
      mod: mod,
      buffered: <<>>
    })
  end

  def handle_call(_request, _from, state), do: {:reply, :ignored, state}

  def handle_cast(_msg, state), do: {:noreply, state}

  def handle_info({:tcp, socket, data}, %{buffered: buffered} = state) do
    Logger.debug(fn -> "Received data from #{inspect(socket)}" end)

    {requests, rest} = unpack_requests(<<buffered::binary, data::binary>>)
    new_state = handle_requests(requests, %{state | buffered: rest})
    {:noreply, new_state}
  end

  def handle_info({:tcp_closed, _socket}, state), do: {:stop, :normal, state}

  def handle_info(_msg, state), do: {:noreply, state}

  def terminate(_reason, _state), do: :ok

  def code_change(_oldvsn, state, _extra), do: {:ok, state}

  @spec decode_varint(binary()) :: :none | {non_neg_integer(), binary()}
  def decode_varint(<<0::1, int::7, rest::binary>>), do: {int, rest}

  def decode_varint(<<1::1, int::7, rest::binary>>) do
    case decode_varint(rest) do
      :none -> :none
      {int1, rest1} -> {int + (int1 <<< 7), rest1}
    end
  end

  def decode_varint(_), do: :none

  @spec decode_zigzag(binary()) :: :none | {integer(), binary()}
  def decode_zigzag(bin) do
    case decode_varint(bin) do
      :none ->
        :none

      {varint, rest} ->
        int =
          case varint &&& 1 do
            1 -> -((varint + 1) >>> 1)
            0 -> varint >>> 1
          end

        {int, rest}
    end
  end

  @spec unpack_requests(binary()) :: {list(Request.t()), rest :: binary()}
  def unpack_requests(<<>>), do: {[], <<>>}

  def unpack_requests(data) do
    case decode_zigzag(data) do
      :none ->
        {[], data}

      {length, rest} ->
        case rest do
          <<msg::binary-size(length), rest1::binary>> ->
            request = Request.decode(msg)
            {rest_requests, rest2} = unpack_requests(rest1)
            {[request | rest_requests], rest2}

          _ ->
            {[], data}
        end
    end
  end

  @spec handle_requests(list(Request.t()), map()) :: map()
  def handle_requests(
        [request | rest_requests],
        %{socket: socket, transport: transport, mod: mod} = state
      ) do
    Logger.debug(fn -> "Received request #{inspect(request)}" end)
    %Request{value: {type, value}} = request

    case type do
      :flush ->
        :ok = send_response(request, state)

      :echo ->
        :ok = send_response(request, state)

      _ ->
        response = apply(mod, :"handle_#{type}", [value])

        case response do
          nil -> nil
          _ -> :ok = send_response(%Response{value: {type, response}}, state)
        end
    end

    handle_requests(rest_requests, state)
  end

  def handle_requests([], state), do: state

  @spec send_response(any(), map()) :: :ok
  def send_response(data, %{socket: socket, transport: transport}) do
    Logger.debug(fn -> "Response: #{inspect(data)}" end)
    response = Response.encode(data)
    length = encode_zigzag(byte_size(response))
    full_response = <<length::binary, response::binary>>
    _ = transport.setopts(socket, active: :once)
    :ok = transport.send(socket, full_response)
    :ok
  end

  @spec encode_varint(non_neg_integer()) :: binary()
  def encode_varint(int), do: encode_varint(int, <<>>)

  def encode_varint(int, acc) do
    group = rem(int, 128)
    rest = int >>> 7

    case rest do
      0 -> <<acc::binary, 0::1, group::7>>
      _ -> encode_varint(rest, <<acc::binary, 1::1, group::7>>)
    end
  end

  @spec encode_zigzag(integer()) :: binary()
  def encode_zigzag(int) do
    zigzag =
      case int >= 0 do
        true -> 2 * int
        false -> -2 * int - 1
      end

    encode_varint(zigzag)
  end
end
