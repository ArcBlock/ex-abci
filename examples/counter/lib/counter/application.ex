defmodule Counter.Application do
  @moduledoc false

  use Application

  alias ExAbci.Listener

  def start(_type, _args) do
    children = [
      Listener.child_spec(Counter.Server),
      Counter.Server
    ]

    opts = [strategy: :one_for_one, name: Counter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
