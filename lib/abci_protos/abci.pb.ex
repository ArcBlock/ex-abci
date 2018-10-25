defmodule Abci.Request do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof :value, 0
  field :echo, 2, type: Abci.RequestEcho, oneof: 0
  field :flush, 3, type: Abci.RequestFlush, oneof: 0
  field :info, 4, type: Abci.RequestInfo, oneof: 0
  field :set_option, 5, type: Abci.RequestSetOption, oneof: 0
  field :init_chain, 6, type: Abci.RequestInitChain, oneof: 0
  field :query, 7, type: Abci.RequestQuery, oneof: 0
  field :begin_block, 8, type: Abci.RequestBeginBlock, oneof: 0
  field :check_tx, 9, type: Abci.RequestCheckTx, oneof: 0
  field :deliver_tx, 19, type: Abci.RequestDeliverTx, oneof: 0
  field :end_block, 11, type: Abci.RequestEndBlock, oneof: 0
  field :commit, 12, type: Abci.RequestCommit, oneof: 0
end

defmodule Abci.RequestEcho do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Abci.RequestFlush do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Abci.RequestInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          version: String.t()
        }
  defstruct [:version]

  field :version, 1, type: :string
end

defmodule Abci.RequestSetOption do
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

defmodule Abci.RequestInitChain do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          time: Google.Protobuf.Timestamp.t(),
          chain_id: String.t(),
          consensus_params: Abci.ConsensusParams.t(),
          validators: [Abci.ValidatorUpdate.t()],
          app_state_bytes: String.t()
        }
  defstruct [:time, :chain_id, :consensus_params, :validators, :app_state_bytes]

  field :time, 1, type: Google.Protobuf.Timestamp
  field :chain_id, 2, type: :string
  field :consensus_params, 3, type: Abci.ConsensusParams
  field :validators, 4, repeated: true, type: Abci.ValidatorUpdate
  field :app_state_bytes, 5, type: :bytes
end

defmodule Abci.RequestQuery do
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

defmodule Abci.RequestBeginBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          hash: String.t(),
          header: Abci.Header.t(),
          last_commit_info: Abci.LastCommitInfo.t(),
          byzantine_validators: [Abci.Evidence.t()]
        }
  defstruct [:hash, :header, :last_commit_info, :byzantine_validators]

  field :hash, 1, type: :bytes
  field :header, 2, type: Abci.Header
  field :last_commit_info, 3, type: Abci.LastCommitInfo
  field :byzantine_validators, 4, repeated: true, type: Abci.Evidence
end

defmodule Abci.RequestCheckTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule Abci.RequestDeliverTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tx: String.t()
        }
  defstruct [:tx]

  field :tx, 1, type: :bytes
end

defmodule Abci.RequestEndBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          height: integer
        }
  defstruct [:height]

  field :height, 1, type: :int64
end

defmodule Abci.RequestCommit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Abci.Response do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof :value, 0
  field :exception, 1, type: Abci.ResponseException, oneof: 0
  field :echo, 2, type: Abci.ResponseEcho, oneof: 0
  field :flush, 3, type: Abci.ResponseFlush, oneof: 0
  field :info, 4, type: Abci.ResponseInfo, oneof: 0
  field :set_option, 5, type: Abci.ResponseSetOption, oneof: 0
  field :init_chain, 6, type: Abci.ResponseInitChain, oneof: 0
  field :query, 7, type: Abci.ResponseQuery, oneof: 0
  field :begin_block, 8, type: Abci.ResponseBeginBlock, oneof: 0
  field :check_tx, 9, type: Abci.ResponseCheckTx, oneof: 0
  field :deliver_tx, 10, type: Abci.ResponseDeliverTx, oneof: 0
  field :end_block, 11, type: Abci.ResponseEndBlock, oneof: 0
  field :commit, 12, type: Abci.ResponseCommit, oneof: 0
end

defmodule Abci.ResponseException do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          error: String.t()
        }
  defstruct [:error]

  field :error, 1, type: :string
end

defmodule Abci.ResponseEcho do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Abci.ResponseFlush do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Abci.ResponseInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: String.t(),
          version: String.t(),
          last_block_height: integer,
          last_block_app_hash: String.t()
        }
  defstruct [:data, :version, :last_block_height, :last_block_app_hash]

  field :data, 1, type: :string
  field :version, 2, type: :string
  field :last_block_height, 3, type: :int64
  field :last_block_app_hash, 4, type: :bytes
end

defmodule Abci.ResponseSetOption do
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

defmodule Abci.ResponseInitChain do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          consensus_params: Abci.ConsensusParams.t(),
          validators: [Abci.ValidatorUpdate.t()]
        }
  defstruct [:consensus_params, :validators]

  field :consensus_params, 1, type: Abci.ConsensusParams
  field :validators, 2, repeated: true, type: Abci.ValidatorUpdate
end

defmodule Abci.ResponseQuery do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          log: String.t(),
          info: String.t(),
          index: integer,
          key: String.t(),
          value: String.t(),
          proof: String.t(),
          height: integer
        }
  defstruct [:code, :log, :info, :index, :key, :value, :proof, :height]

  field :code, 1, type: :uint32
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :index, 5, type: :int64
  field :key, 6, type: :bytes
  field :value, 7, type: :bytes
  field :proof, 8, type: :bytes
  field :height, 9, type: :int64
end

defmodule Abci.ResponseBeginBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          tags: [Common.KVPair.t()]
        }
  defstruct [:tags]

  field :tags, 1, repeated: true, type: Common.KVPair
end

defmodule Abci.ResponseCheckTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          data: String.t(),
          log: String.t(),
          info: String.t(),
          gas_wanted: integer,
          gas_used: integer,
          tags: [Common.KVPair.t()]
        }
  defstruct [:code, :data, :log, :info, :gas_wanted, :gas_used, :tags]

  field :code, 1, type: :uint32
  field :data, 2, type: :bytes
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :gas_wanted, 5, type: :int64
  field :gas_used, 6, type: :int64
  field :tags, 7, repeated: true, type: Common.KVPair
end

defmodule Abci.ResponseDeliverTx do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          code: non_neg_integer,
          data: String.t(),
          log: String.t(),
          info: String.t(),
          gas_wanted: integer,
          gas_used: integer,
          tags: [Common.KVPair.t()]
        }
  defstruct [:code, :data, :log, :info, :gas_wanted, :gas_used, :tags]

  field :code, 1, type: :uint32
  field :data, 2, type: :bytes
  field :log, 3, type: :string
  field :info, 4, type: :string
  field :gas_wanted, 5, type: :int64
  field :gas_used, 6, type: :int64
  field :tags, 7, repeated: true, type: Common.KVPair
end

defmodule Abci.ResponseEndBlock do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          validator_updates: [Abci.ValidatorUpdate.t()],
          consensus_param_updates: Abci.ConsensusParams.t(),
          tags: [Common.KVPair.t()]
        }
  defstruct [:validator_updates, :consensus_param_updates, :tags]

  field :validator_updates, 1, repeated: true, type: Abci.ValidatorUpdate
  field :consensus_param_updates, 2, type: Abci.ConsensusParams
  field :tags, 3, repeated: true, type: Common.KVPair
end

defmodule Abci.ResponseCommit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          data: String.t()
        }
  defstruct [:data]

  field :data, 2, type: :bytes
end

defmodule Abci.ConsensusParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          block_size: Abci.BlockSize.t(),
          evidence_params: Abci.EvidenceParams.t()
        }
  defstruct [:block_size, :evidence_params]

  field :block_size, 1, type: Abci.BlockSize
  field :evidence_params, 2, type: Abci.EvidenceParams
end

defmodule Abci.BlockSize do
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

defmodule Abci.EvidenceParams do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          max_age: integer
        }
  defstruct [:max_age]

  field :max_age, 1, type: :int64
end

defmodule Abci.LastCommitInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          round: integer,
          votes: [Abci.VoteInfo.t()]
        }
  defstruct [:round, :votes]

  field :round, 1, type: :int32
  field :votes, 2, repeated: true, type: Abci.VoteInfo
end

defmodule Abci.Header do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          chain_id: String.t(),
          height: integer,
          time: Google.Protobuf.Timestamp.t(),
          num_txs: integer,
          total_txs: integer,
          last_block_id: Abci.BlockID.t(),
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

  field :chain_id, 1, type: :string
  field :height, 2, type: :int64
  field :time, 3, type: Google.Protobuf.Timestamp
  field :num_txs, 4, type: :int64
  field :total_txs, 5, type: :int64
  field :last_block_id, 6, type: Abci.BlockID
  field :last_commit_hash, 7, type: :bytes
  field :data_hash, 8, type: :bytes
  field :validators_hash, 9, type: :bytes
  field :next_validators_hash, 10, type: :bytes
  field :consensus_hash, 11, type: :bytes
  field :app_hash, 12, type: :bytes
  field :last_results_hash, 13, type: :bytes
  field :evidence_hash, 14, type: :bytes
  field :proposer_address, 15, type: :bytes
end

defmodule Abci.BlockID do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          hash: String.t(),
          parts_header: Abci.PartSetHeader.t()
        }
  defstruct [:hash, :parts_header]

  field :hash, 1, type: :bytes
  field :parts_header, 2, type: Abci.PartSetHeader
end

defmodule Abci.PartSetHeader do
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

defmodule Abci.Validator do
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

defmodule Abci.ValidatorUpdate do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pub_key: Abci.PubKey.t(),
          power: integer
        }
  defstruct [:pub_key, :power]

  field :pub_key, 1, type: Abci.PubKey
  field :power, 2, type: :int64
end

defmodule Abci.VoteInfo do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          validator: Abci.Validator.t(),
          signed_last_block: boolean
        }
  defstruct [:validator, :signed_last_block]

  field :validator, 1, type: Abci.Validator
  field :signed_last_block, 2, type: :bool
end

defmodule Abci.PubKey do
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

defmodule Abci.Evidence do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: String.t(),
          validator: Abci.Validator.t(),
          height: integer,
          time: Google.Protobuf.Timestamp.t(),
          total_voting_power: integer
        }
  defstruct [:type, :validator, :height, :time, :total_voting_power]

  field :type, 1, type: :string
  field :validator, 2, type: Abci.Validator
  field :height, 3, type: :int64
  field :time, 4, type: Google.Protobuf.Timestamp
  field :total_voting_power, 5, type: :int64
end
