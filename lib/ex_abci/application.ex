defmodule ExAbci.Application do
  @moduledoc false
  alias ExAbci.Listener

  use Application

  def start(_type, _args) do
    children = [
      Listener.child_spec(ExAbci.Server, 26658)
    ]

    opts = [strategy: :one_for_one, name: ExAbci.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
