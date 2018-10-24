defmodule SimpleChain.Application do
  @moduledoc false
  use Application
  alias ExAbci.Listener

  def start(_type, _args) do
    children = [
      Listener.child_spec(SimpleChain.Server),
      SimpleChain.Server
    ]

    opts = [strategy: :one_for_one, name: Kvstore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
