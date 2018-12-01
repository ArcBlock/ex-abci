defmodule ExAbci.Listener do
  @moduledoc """
  Gen Server for ABCI interface, using ranch
  """
  use GenServer

  require Logger

  alias Abci.{Request, Response}
  alias ExAbci.{Server, Varint}

  @behaviour :ranch_protocol

  @spec start_link(reference(), any(), atom(), list()) :: {:ok, pid}
  def start_link(ref, socket, transport, opts) do
    {:ok, :proc_lib.spawn_link(__MODULE__, :init, [{ref, socket, transport, opts}])}
  end

  @spec start_listener(module()) :: :supervisor.startchild_ret()
  def start_listener(mod), do: apply(:ranch, :start_listener, gen_ranch_args(mod))

  @spec child_spec(module()) :: :supervisor.child_spec()
  def child_spec(mod), do: apply(:ranch, :child_spec, gen_ranch_args(mod))

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

  def handle_info(msg, state) do
    Logger.debug(fn -> "Received unkown message: #{inspect(msg)}" end)
    {:noreply, state}
  end

  def terminate(_reason, _state), do: :ok

  def code_change(_oldvsn, state, _extra), do: {:ok, state}

  # see: https://github.com/tendermint/abci#socket-tsp
  @spec unpack_requests(binary()) :: {list(Request.t()), rest :: binary()}
  def unpack_requests(<<>>), do: {[], <<>>}

  def unpack_requests(data) do
    case Varint.decode_zigzag(data) do
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
  def handle_requests([request | rest_requests], %{mod: mod} = state) do
    Logger.debug(fn -> "Received request #{inspect(request)}" end)
    %Request{value: {type, value}} = request

    case type do
      :flush ->
        :ok = send_response(request, state)

      :echo ->
        :ok = send_response(request, state)

      _ ->
        handler = :"handle_#{type}"

        response =
          try do
            apply(mod, handler, [value])
          rescue
            _ ->
              apply(Server, handler, [value])
          end

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
    length = Varint.encode_zigzag(byte_size(response))
    full_response = <<length::binary, response::binary>>
    _ = transport.setopts(socket, active: :once)
    :ok = transport.send(socket, full_response)
    :ok
  end

  # private functions

  @spec gen_ranch_args(module()) :: term()
  def gen_ranch_args(mod) do
    opts =
      Application.get_env(:ex_abci, :ranch_opts,
        port: 26658,
        max_connections: 3,
        buffer: 65535,
        sndbuf: 65535,
        recbuf: 65535
      )

    [mod, :ranch_tcp, opts, ExAbci.Listener, [mod]]
  end
end
