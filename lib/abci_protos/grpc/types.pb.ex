defmodule CoreGrpc.RequestPing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule CoreGrpc.RequestBroadcastTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule CoreGrpc.ResponsePing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule CoreGrpc.ResponseBroadcastTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          check_tx: Types.ResponseCheckTx.t(),
          deliver_tx: Types.ResponseDeliverTx.t()
        }
  defstruct [:check_tx, :deliver_tx]

  field :check_tx, 1, type: Types.ResponseCheckTx
  field :deliver_tx, 2, type: Types.ResponseDeliverTx
end

defmodule CoreGrpc.BroadcastAPI.Service do
  @moduledoc false
  use GRPC.Service, name: "core_grpc.BroadcastAPI"

  rpc(:Ping, CoreGrpc.RequestPing, CoreGrpc.ResponsePing)
  rpc(:BroadcastTx, CoreGrpc.RequestBroadcastTx, CoreGrpc.ResponseBroadcastTx)
end

defmodule CoreGrpc.BroadcastAPI.Stub do
  @moduledoc false
  use GRPC.Stub, service: CoreGrpc.BroadcastAPI.Service
end
