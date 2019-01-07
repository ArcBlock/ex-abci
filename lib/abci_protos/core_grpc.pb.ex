defmodule CoreGrpc.BroadcastAPI.Service do
  @moduledoc false
  use GRPC.Service, name: "core_grpc.BroadcastAPI"

  rpc :Ping, ForgeVendor.RequestPing, ForgeVendor.ResponsePing
  rpc :BroadcastTx, ForgeVendor.RequestBroadcastTx, ForgeVendor.ResponseBroadcastTx
end

defmodule CoreGrpc.BroadcastAPI.Stub do
  @moduledoc false
  use GRPC.Stub, service: CoreGrpc.BroadcastAPI.Service
end
