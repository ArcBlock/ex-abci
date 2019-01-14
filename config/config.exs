use Mix.Config

config :ex_abci,
  ranch_opts: %{
    max_connections: 3,
    socket_opts: [port: 26658, buffer: 65535, sndbuf: 65535, recbuf: 65535]
  }

config :logger, level: :debug
