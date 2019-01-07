defmodule ForgeVendor.KVPair do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field :key, 1, type: :bytes
  field :value, 2, type: :bytes
end

defmodule ForgeVendor.ProofOp do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: String.t(),
          key: String.t(),
          data: String.t()
        }
  defstruct [:type, :key, :data]

  field :type, 1, type: :string
  field :key, 2, type: :bytes
  field :data, 3, type: :bytes
end

defmodule ForgeVendor.Proof do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          ops: [ForgeVendor.ProofOp.t()]
        }
  defstruct [:ops]

  field :ops, 1, repeated: true, type: ForgeVendor.ProofOp
end

defmodule ForgeVendor.RequestPing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule ForgeVendor.RequestBroadcastTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule ForgeVendor.ResponsePing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule ForgeVendor.ResponseBroadcastTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          check_tx: ForgeVendor.ResponseCheckTx.t(),
          deliver_tx: ForgeVendor.ResponseDeliverTx.t()
        }
  defstruct [:check_tx, :deliver_tx]

  field :check_tx, 1, type: ForgeVendor.ResponseCheckTx
  field :deliver_tx, 2, type: ForgeVendor.ResponseDeliverTx
end

defmodule ForgeVendor.Request do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof :value, 0
  field :echo, 2, type: ForgeVendor.RequestEcho, oneof: 0
  field :flush, 3, type: ForgeVendor.RequestFlush, oneof: 0
  field :info, 4, type: ForgeVendor.RequestInfo, oneof: 0
  field :set_option, 5, type: ForgeVendor.RequestSetOption, oneof: 0
  field :init_chain, 6, type: ForgeVendor.RequestInitChain, oneof: 0
  field :query, 7, type: ForgeVendor.RequestQuery, oneof: 0
  field :begin_block, 8, type: ForgeVendor.RequestBeginBlock, oneof: 0
  field :check_tx, 9, type: ForgeVendor.RequestCheckTx, oneof: 0
  field :deliver_tx, 19, type: ForgeVendor.RequestDeliverTx, oneof: 0
  field :end_block, 11, type: ForgeVendor.RequestEndBlock, oneof: 0
  field :commit, 12, type: ForgeVendor.RequestCommit, oneof: 0
end

defmodule ForgeVendor.RequestEcho do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule ForgeVendor.RequestFlush do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule ForgeVendor.RequestInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          version: String.t(),
          block_version: non_neg_integer,
          p2p_version: non_neg_integer
        }
  defstruct [:version, :block_version, :p2p_version]

  field :version, 1, type: :string
  field :block_version, 2, type: :uint64
  field :p2p_version, 3, type: :uint64
end

defmodule ForgeVendor.RequestSetOption do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule ForgeVendor.RequestInitChain do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          time: Google.Protobuf.Timestamp.t(),
          chain_id: String.t(),
          consensus_params: ForgeVendor.ConsensusParams.t(),
          validators: [ForgeVendor.ValidatorUpdate.t()],
          app_state_bytes: String.t()
        }
  defstruct [:time, :chain_id, :consensus_params, :validators, :app_state_bytes]

  field :time, 1, type: Google.Protobuf.Timestamp
  field :chain_id, 2, type: :string
  field :consensus_params, 3, type: ForgeVendor.ConsensusParams
  field :validators, 4, repeated: true, type: ForgeVendor.ValidatorUpdate
  field :app_state_bytes, 5, type: :bytes
end

defmodule ForgeVendor.RequestQuery do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: String.t(),
          path: String.t(),
          height: integer,
          prove: boolean
        }
  defstruct [:data, :path, :height, :prove]

  field :data, 1, type: :bytes
  field :path, 2, type: :string
  field :height, 3, type: :int64
  field :prove, 4, type: :bool
end

defmodule ForgeVendor.RequestBeginBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          hash: String.t(),
          header: ForgeVendor.Header.t(),
          last_commit_info: ForgeVendor.LastCommitInfo.t(),
          byzantine_validators: [ForgeVendor.Evidence.t()]
        }
  defstruct [:hash, :header, :last_commit_info, :byzantine_validators]

  field :hash, 1, type: :bytes
  field :header, 2, type: ForgeVendor.Header
  field :last_commit_info, 3, type: ForgeVendor.LastCommitInfo
  field :byzantine_validators, 4, repeated: true, type: ForgeVendor.Evidence
end

defmodule ForgeVendor.RequestCheckTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule ForgeVendor.RequestDeliverTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule ForgeVendor.RequestEndBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          height: integer
        }
  defstruct [:height]

  field :height, 1, type: :int64
end

defmodule ForgeVendor.RequestCommit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule ForgeVendor.Response do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof :value, 0
  field :exception, 1, type: ForgeVendor.ResponseException, oneof: 0
  field :echo, 2, type: ForgeVendor.ResponseEcho, oneof: 0
  field :flush, 3, type: ForgeVendor.ResponseFlush, oneof: 0
  field :info, 4, type: ForgeVendor.ResponseInfo, oneof: 0
  field :set_option, 5, type: ForgeVendor.ResponseSetOption, oneof: 0
  field :init_chain, 6, type: ForgeVendor.ResponseInitChain, oneof: 0
  field :query, 7, type: ForgeVendor.ResponseQuery, oneof: 0
  field :begin_block, 8, type: ForgeVendor.ResponseBeginBlock, oneof: 0
  field :check_tx, 9, type: ForgeVendor.ResponseCheckTx, oneof: 0
  field :deliver_tx, 10, type: ForgeVendor.ResponseDeliverTx, oneof: 0
  field :end_block, 11, type: ForgeVendor.ResponseEndBlock, oneof: 0
  field :commit, 12, type: ForgeVendor.ResponseCommit, oneof: 0
end

defmodule ForgeVendor.ResponseException do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          error: String.t()
        }
  defstruct [:error]

  field :error, 1, type: :string
end

defmodule ForgeVendor.ResponseEcho do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule ForgeVendor.ResponseFlush do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule ForgeVendor.ResponseInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: String.t(),
          version: String.t(),
          app_version: non_neg_integer,
          last_block_height: integer,
          last_block_app_hash: String.t()
        }
  defstruct [:data, :version, :app_version, :last_block_height, :last_block_app_hash]

  field :data, 1, type: :string
  field :version, 2, type: :string
  field :app_version, 3, type: :uint64
  field :last_block_height, 4, type: :int64
  field :last_block_app_hash, 5, type: :bytes
end

defmodule ForgeVendor.ResponseSetOption do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          log: String.t(),
          info: String.t()
        }
  defstruct [:code, :log, :info]

  field :code, 1, type: :uint32
  field :log, 3, type: :string
  field :info, 4, type: :string
end

defmodule ForgeVendor.ResponseInitChain do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          consensus_params: ForgeVendor.ConsensusParams.t(),
          validators: [ForgeVendor.ValidatorUpdate.t()]
        }
  defstruct [:consensus_params, :validators]

  field :consensus_params, 1, type: ForgeVendor.ConsensusParams
  field :validators, 2, repeated: true, type: ForgeVendor.ValidatorUpdate
end

defmodule ForgeVendor.ResponseQuery do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          log: String.t(),
          info: String.t(),
          index: integer,
          key: String.t(),
          value: String.t(),
          proof: ForgeVendor.Proof.t(),
          height: integer,
          codespace: String.t()
        }
  defstruct [:code, :log, :info, :index, :key, :value, :proof, :height, :codespace]

  field :code, 1, type: :uint32
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :index, 5, type: :int64
  field :key, 6, type: :bytes
  field :value, 7, type: :bytes
  field :proof, 8, type: ForgeVendor.Proof
  field :height, 9, type: :int64
  field :codespace, 10, type: :string
end

defmodule ForgeVendor.ResponseBeginBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tags: [ForgeVendor.KVPair.t()]
        }
  defstruct [:tags]

  field :tags, 1, repeated: true, type: ForgeVendor.KVPair
end

defmodule ForgeVendor.ResponseCheckTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          data: String.t(),
          log: String.t(),
          info: String.t(),
          gas_wanted: integer,
          gas_used: integer,
          tags: [ForgeVendor.KVPair.t()],
          codespace: String.t()
        }
  defstruct [:code, :data, :log, :info, :gas_wanted, :gas_used, :tags, :codespace]

  field :code, 1, type: :uint32
  field :data, 2, type: :bytes
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :gas_wanted, 5, type: :int64
  field :gas_used, 6, type: :int64
  field :tags, 7, repeated: true, type: ForgeVendor.KVPair
  field :codespace, 8, type: :string
end

defmodule ForgeVendor.ResponseDeliverTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          data: String.t(),
          log: String.t(),
          info: String.t(),
          gas_wanted: integer,
          gas_used: integer,
          tags: [ForgeVendor.KVPair.t()],
          codespace: String.t()
        }
  defstruct [:code, :data, :log, :info, :gas_wanted, :gas_used, :tags, :codespace]

  field :code, 1, type: :uint32
  field :data, 2, type: :bytes
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :gas_wanted, 5, type: :int64
  field :gas_used, 6, type: :int64
  field :tags, 7, repeated: true, type: ForgeVendor.KVPair
  field :codespace, 8, type: :string
end

defmodule ForgeVendor.ResponseEndBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          validator_updates: [ForgeVendor.ValidatorUpdate.t()],
          consensus_param_updates: ForgeVendor.ConsensusParams.t(),
          tags: [ForgeVendor.KVPair.t()]
        }
  defstruct [:validator_updates, :consensus_param_updates, :tags]

  field :validator_updates, 1, repeated: true, type: ForgeVendor.ValidatorUpdate
  field :consensus_param_updates, 2, type: ForgeVendor.ConsensusParams
  field :tags, 3, repeated: true, type: ForgeVendor.KVPair
end

defmodule ForgeVendor.ResponseCommit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: String.t()
        }
  defstruct [:data]

  field :data, 2, type: :bytes
end

defmodule ForgeVendor.ConsensusParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          block_size: ForgeVendor.BlockSizeParams.t(),
          evidence: ForgeVendor.EvidenceParams.t(),
          validator: ForgeVendor.ValidatorParams.t()
        }
  defstruct [:block_size, :evidence, :validator]

  field :block_size, 1, type: ForgeVendor.BlockSizeParams
  field :evidence, 2, type: ForgeVendor.EvidenceParams
  field :validator, 3, type: ForgeVendor.ValidatorParams
end

defmodule ForgeVendor.BlockSizeParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          max_bytes: integer,
          max_gas: integer
        }
  defstruct [:max_bytes, :max_gas]

  field :max_bytes, 1, type: :int64
  field :max_gas, 2, type: :int64
end

defmodule ForgeVendor.EvidenceParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          max_age: integer
        }
  defstruct [:max_age]

  field :max_age, 1, type: :int64
end

defmodule ForgeVendor.ValidatorParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pub_key_types: [String.t()]
        }
  defstruct [:pub_key_types]

  field :pub_key_types, 1, repeated: true, type: :string
end

defmodule ForgeVendor.LastCommitInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          round: integer,
          votes: [ForgeVendor.VoteInfo.t()]
        }
  defstruct [:round, :votes]

  field :round, 1, type: :int32
  field :votes, 2, repeated: true, type: ForgeVendor.VoteInfo
end

defmodule ForgeVendor.Header do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          version: ForgeVendor.Version.t(),
          chain_id: String.t(),
          height: integer,
          time: Google.Protobuf.Timestamp.t(),
          num_txs: integer,
          total_txs: integer,
          last_block_id: ForgeVendor.BlockID.t(),
          last_commit_hash: String.t(),
          data_hash: String.t(),
          validators_hash: String.t(),
          next_validators_hash: String.t(),
          consensus_hash: String.t(),
          app_hash: String.t(),
          last_results_hash: String.t(),
          evidence_hash: String.t(),
          proposer_address: String.t()
        }
  defstruct [
    :version,
    :chain_id,
    :height,
    :time,
    :num_txs,
    :total_txs,
    :last_block_id,
    :last_commit_hash,
    :data_hash,
    :validators_hash,
    :next_validators_hash,
    :consensus_hash,
    :app_hash,
    :last_results_hash,
    :evidence_hash,
    :proposer_address
  ]

  field :version, 1, type: ForgeVendor.Version
  field :chain_id, 2, type: :string
  field :height, 3, type: :int64
  field :time, 4, type: Google.Protobuf.Timestamp
  field :num_txs, 5, type: :int64
  field :total_txs, 6, type: :int64
  field :last_block_id, 7, type: ForgeVendor.BlockID
  field :last_commit_hash, 8, type: :bytes
  field :data_hash, 9, type: :bytes
  field :validators_hash, 10, type: :bytes
  field :next_validators_hash, 11, type: :bytes
  field :consensus_hash, 12, type: :bytes
  field :app_hash, 13, type: :bytes
  field :last_results_hash, 14, type: :bytes
  field :evidence_hash, 15, type: :bytes
  field :proposer_address, 16, type: :bytes
end

defmodule ForgeVendor.Version do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          Block: non_neg_integer,
          App: non_neg_integer
        }
  defstruct [:Block, :App]

  field :Block, 1, type: :uint64
  field :App, 2, type: :uint64
end

defmodule ForgeVendor.BlockID do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          hash: String.t(),
          parts_header: ForgeVendor.PartSetHeader.t()
        }
  defstruct [:hash, :parts_header]

  field :hash, 1, type: :bytes
  field :parts_header, 2, type: ForgeVendor.PartSetHeader
end

defmodule ForgeVendor.PartSetHeader do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          total: integer,
          hash: String.t()
        }
  defstruct [:total, :hash]

  field :total, 1, type: :int32
  field :hash, 2, type: :bytes
end

defmodule ForgeVendor.Validator do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          address: String.t(),
          power: integer
        }
  defstruct [:address, :power]

  field :address, 1, type: :bytes
  field :power, 3, type: :int64
end

defmodule ForgeVendor.ValidatorUpdate do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pub_key: ForgeVendor.PubKey.t(),
          power: integer
        }
  defstruct [:pub_key, :power]

  field :pub_key, 1, type: ForgeVendor.PubKey
  field :power, 2, type: :int64
end

defmodule ForgeVendor.VoteInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          validator: ForgeVendor.Validator.t(),
          signed_last_block: boolean
        }
  defstruct [:validator, :signed_last_block]

  field :validator, 1, type: ForgeVendor.Validator
  field :signed_last_block, 2, type: :bool
end

defmodule ForgeVendor.PubKey do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: String.t(),
          data: String.t()
        }
  defstruct [:type, :data]

  field :type, 1, type: :string
  field :data, 2, type: :bytes
end

defmodule ForgeVendor.Evidence do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: String.t(),
          validator: ForgeVendor.Validator.t(),
          height: integer,
          time: Google.Protobuf.Timestamp.t(),
          total_voting_power: integer
        }
  defstruct [:type, :validator, :height, :time, :total_voting_power]

  field :type, 1, type: :string
  field :validator, 2, type: ForgeVendor.Validator
  field :height, 3, type: :int64
  field :time, 4, type: Google.Protobuf.Timestamp
  field :total_voting_power, 5, type: :int64
end

defmodule ForgeVendor.ABCIApplication.Service do
  @moduledoc false
  use GRPC.Service, name: "forge_vendor.ABCIApplication"

  rpc :Echo, ForgeVendor.RequestEcho, ForgeVendor.ResponseEcho
  rpc :Flush, ForgeVendor.RequestFlush, ForgeVendor.ResponseFlush
  rpc :Info, ForgeVendor.RequestInfo, ForgeVendor.ResponseInfo
  rpc :SetOption, ForgeVendor.RequestSetOption, ForgeVendor.ResponseSetOption
  rpc :DeliverTx, ForgeVendor.RequestDeliverTx, ForgeVendor.ResponseDeliverTx
  rpc :CheckTx, ForgeVendor.RequestCheckTx, ForgeVendor.ResponseCheckTx
  rpc :Query, ForgeVendor.RequestQuery, ForgeVendor.ResponseQuery
  rpc :Commit, ForgeVendor.RequestCommit, ForgeVendor.ResponseCommit
  rpc :InitChain, ForgeVendor.RequestInitChain, ForgeVendor.ResponseInitChain
  rpc :BeginBlock, ForgeVendor.RequestBeginBlock, ForgeVendor.ResponseBeginBlock
  rpc :EndBlock, ForgeVendor.RequestEndBlock, ForgeVendor.ResponseEndBlock
end

defmodule ForgeVendor.ABCIApplication.Stub do
  @moduledoc false
  use GRPC.Stub, service: ForgeVendor.ABCIApplication.Service
end
