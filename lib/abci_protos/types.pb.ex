defmodule Types.Request do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof :value, 0
  field :echo, 2, type: Types.RequestEcho, oneof: 0
  field :flush, 3, type: Types.RequestFlush, oneof: 0
  field :info, 4, type: Types.RequestInfo, oneof: 0
  field :set_option, 5, type: Types.RequestSetOption, oneof: 0
  field :init_chain, 6, type: Types.RequestInitChain, oneof: 0
  field :query, 7, type: Types.RequestQuery, oneof: 0
  field :begin_block, 8, type: Types.RequestBeginBlock, oneof: 0
  field :check_tx, 9, type: Types.RequestCheckTx, oneof: 0
  field :deliver_tx, 19, type: Types.RequestDeliverTx, oneof: 0
  field :end_block, 11, type: Types.RequestEndBlock, oneof: 0
  field :commit, 12, type: Types.RequestCommit, oneof: 0
end

defmodule Types.RequestEcho do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Types.RequestFlush do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Types.RequestInfo do
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

defmodule Types.RequestSetOption do
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

defmodule Types.RequestInitChain do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          time: Google.Protobuf.Timestamp.t(),
          chain_id: String.t(),
          consensus_params: Types.ConsensusParams.t(),
          validators: [Types.ValidatorUpdate.t()],
          app_state_bytes: String.t()
        }
  defstruct [:time, :chain_id, :consensus_params, :validators, :app_state_bytes]

  field :time, 1, type: Google.Protobuf.Timestamp
  field :chain_id, 2, type: :string
  field :consensus_params, 3, type: Types.ConsensusParams
  field :validators, 4, repeated: true, type: Types.ValidatorUpdate
  field :app_state_bytes, 5, type: :bytes
end

defmodule Types.RequestQuery do
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

defmodule Types.RequestBeginBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          hash: String.t(),
          header: Types.Header.t(),
          last_commit_info: Types.LastCommitInfo.t(),
          byzantine_validators: [Types.Evidence.t()]
        }
  defstruct [:hash, :header, :last_commit_info, :byzantine_validators]

  field :hash, 1, type: :bytes
  field :header, 2, type: Types.Header
  field :last_commit_info, 3, type: Types.LastCommitInfo
  field :byzantine_validators, 4, repeated: true, type: Types.Evidence
end

defmodule Types.RequestCheckTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule Types.RequestDeliverTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule Types.RequestEndBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          height: integer
        }
  defstruct [:height]

  field :height, 1, type: :int64
end

defmodule Types.RequestCommit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Types.Response do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof :value, 0
  field :exception, 1, type: Types.ResponseException, oneof: 0
  field :echo, 2, type: Types.ResponseEcho, oneof: 0
  field :flush, 3, type: Types.ResponseFlush, oneof: 0
  field :info, 4, type: Types.ResponseInfo, oneof: 0
  field :set_option, 5, type: Types.ResponseSetOption, oneof: 0
  field :init_chain, 6, type: Types.ResponseInitChain, oneof: 0
  field :query, 7, type: Types.ResponseQuery, oneof: 0
  field :begin_block, 8, type: Types.ResponseBeginBlock, oneof: 0
  field :check_tx, 9, type: Types.ResponseCheckTx, oneof: 0
  field :deliver_tx, 10, type: Types.ResponseDeliverTx, oneof: 0
  field :end_block, 11, type: Types.ResponseEndBlock, oneof: 0
  field :commit, 12, type: Types.ResponseCommit, oneof: 0
end

defmodule Types.ResponseException do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          error: String.t()
        }
  defstruct [:error]

  field :error, 1, type: :string
end

defmodule Types.ResponseEcho do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Types.ResponseFlush do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Types.ResponseInfo do
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

defmodule Types.ResponseSetOption do
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

defmodule Types.ResponseInitChain do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          consensus_params: Types.ConsensusParams.t(),
          validators: [Types.ValidatorUpdate.t()]
        }
  defstruct [:consensus_params, :validators]

  field :consensus_params, 1, type: Types.ConsensusParams
  field :validators, 2, repeated: true, type: Types.ValidatorUpdate
end

defmodule Types.ResponseQuery do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          log: String.t(),
          info: String.t(),
          index: integer,
          key: String.t(),
          value: String.t(),
          proof: Merkle.Proof.t(),
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
  field :proof, 8, type: Merkle.Proof
  field :height, 9, type: :int64
  field :codespace, 10, type: :string
end

defmodule Types.ResponseBeginBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tags: [Common.KVPair.t()]
        }
  defstruct [:tags]

  field :tags, 1, repeated: true, type: Common.KVPair
end

defmodule Types.ResponseCheckTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          data: String.t(),
          log: String.t(),
          info: String.t(),
          gas_wanted: integer,
          gas_used: integer,
          tags: [Common.KVPair.t()],
          codespace: String.t()
        }
  defstruct [:code, :data, :log, :info, :gas_wanted, :gas_used, :tags, :codespace]

  field :code, 1, type: :uint32
  field :data, 2, type: :bytes
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :gas_wanted, 5, type: :int64
  field :gas_used, 6, type: :int64
  field :tags, 7, repeated: true, type: Common.KVPair
  field :codespace, 8, type: :string
end

defmodule Types.ResponseDeliverTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          data: String.t(),
          log: String.t(),
          info: String.t(),
          gas_wanted: integer,
          gas_used: integer,
          tags: [Common.KVPair.t()],
          codespace: String.t()
        }
  defstruct [:code, :data, :log, :info, :gas_wanted, :gas_used, :tags, :codespace]

  field :code, 1, type: :uint32
  field :data, 2, type: :bytes
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :gas_wanted, 5, type: :int64
  field :gas_used, 6, type: :int64
  field :tags, 7, repeated: true, type: Common.KVPair
  field :codespace, 8, type: :string
end

defmodule Types.ResponseEndBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          validator_updates: [Types.ValidatorUpdate.t()],
          consensus_param_updates: Types.ConsensusParams.t(),
          tags: [Common.KVPair.t()]
        }
  defstruct [:validator_updates, :consensus_param_updates, :tags]

  field :validator_updates, 1, repeated: true, type: Types.ValidatorUpdate
  field :consensus_param_updates, 2, type: Types.ConsensusParams
  field :tags, 3, repeated: true, type: Common.KVPair
end

defmodule Types.ResponseCommit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: String.t()
        }
  defstruct [:data]

  field :data, 2, type: :bytes
end

defmodule Types.ConsensusParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          block_size: Types.BlockSizeParams.t(),
          evidence: Types.EvidenceParams.t(),
          validator: Types.ValidatorParams.t()
        }
  defstruct [:block_size, :evidence, :validator]

  field :block_size, 1, type: Types.BlockSizeParams
  field :evidence, 2, type: Types.EvidenceParams
  field :validator, 3, type: Types.ValidatorParams
end

defmodule Types.BlockSizeParams do
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

defmodule Types.EvidenceParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          max_age: integer
        }
  defstruct [:max_age]

  field :max_age, 1, type: :int64
end

defmodule Types.ValidatorParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pub_key_types: [String.t()]
        }
  defstruct [:pub_key_types]

  field :pub_key_types, 1, repeated: true, type: :string
end

defmodule Types.LastCommitInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          round: integer,
          votes: [Types.VoteInfo.t()]
        }
  defstruct [:round, :votes]

  field :round, 1, type: :int32
  field :votes, 2, repeated: true, type: Types.VoteInfo
end

defmodule Types.Header do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          version: Types.Version.t(),
          chain_id: String.t(),
          height: integer,
          time: Google.Protobuf.Timestamp.t(),
          num_txs: integer,
          total_txs: integer,
          last_block_id: Types.BlockID.t(),
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

  field :version, 1, type: Types.Version
  field :chain_id, 2, type: :string
  field :height, 3, type: :int64
  field :time, 4, type: Google.Protobuf.Timestamp
  field :num_txs, 5, type: :int64
  field :total_txs, 6, type: :int64
  field :last_block_id, 7, type: Types.BlockID
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

defmodule Types.Version do
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

defmodule Types.BlockID do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          hash: String.t(),
          parts_header: Types.PartSetHeader.t()
        }
  defstruct [:hash, :parts_header]

  field :hash, 1, type: :bytes
  field :parts_header, 2, type: Types.PartSetHeader
end

defmodule Types.PartSetHeader do
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

defmodule Types.Validator do
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

defmodule Types.ValidatorUpdate do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pub_key: Types.PubKey.t(),
          power: integer
        }
  defstruct [:pub_key, :power]

  field :pub_key, 1, type: Types.PubKey
  field :power, 2, type: :int64
end

defmodule Types.VoteInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          validator: Types.Validator.t(),
          signed_last_block: boolean
        }
  defstruct [:validator, :signed_last_block]

  field :validator, 1, type: Types.Validator
  field :signed_last_block, 2, type: :bool
end

defmodule Types.PubKey do
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

defmodule Types.Evidence do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: String.t(),
          validator: Types.Validator.t(),
          height: integer,
          time: Google.Protobuf.Timestamp.t(),
          total_voting_power: integer
        }
  defstruct [:type, :validator, :height, :time, :total_voting_power]

  field :type, 1, type: :string
  field :validator, 2, type: Types.Validator
  field :height, 3, type: :int64
  field :time, 4, type: Google.Protobuf.Timestamp
  field :total_voting_power, 5, type: :int64
end

defmodule Types.ABCIApplication.Service do
  @moduledoc false
  use GRPC.Service, name: "types.ABCIApplication"

  rpc(:Echo, Types.RequestEcho, Types.ResponseEcho)
  rpc(:Flush, Types.RequestFlush, Types.ResponseFlush)
  rpc(:Info, Types.RequestInfo, Types.ResponseInfo)
  rpc(:SetOption, Types.RequestSetOption, Types.ResponseSetOption)
  rpc(:DeliverTx, Types.RequestDeliverTx, Types.ResponseDeliverTx)
  rpc(:CheckTx, Types.RequestCheckTx, Types.ResponseCheckTx)
  rpc(:Query, Types.RequestQuery, Types.ResponseQuery)
  rpc(:Commit, Types.RequestCommit, Types.ResponseCommit)
  rpc(:InitChain, Types.RequestInitChain, Types.ResponseInitChain)
  rpc(:BeginBlock, Types.RequestBeginBlock, Types.ResponseBeginBlock)
  rpc(:EndBlock, Types.RequestEndBlock, Types.ResponseEndBlock)
end

defmodule Types.ABCIApplication.Stub do
  @moduledoc false
  use GRPC.Stub, service: Types.ABCIApplication.Service
end
