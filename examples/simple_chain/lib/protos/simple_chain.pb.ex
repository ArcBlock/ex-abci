defmodule SimpleChain.Transaction do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          from: String.t(),
          to: String.t(),
          nonce: non_neg_integer,
          total: non_neg_integer,
          pub_key: String.t(),
          signature: String.t()
        }
  defstruct [:from, :to, :nonce, :total, :pub_key, :signature]

  field :from, 1, type: :bytes
  field :to, 2, type: :bytes
  field :nonce, 3, type: :uint64
  field :total, 4, type: :uint64
  field :pub_key, 5, type: :bytes
  field :signature, 6, type: :bytes
end

defmodule SimpleChain.AccountState do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          balance: non_neg_integer,
          nonce: non_neg_integer,
          num_txs: non_neg_integer
        }
  defstruct [:balance, :nonce, :num_txs]

  field :balance, 1, type: :uint64
  field :nonce, 2, type: :uint64
  field :num_txs, 3, type: :uint64
end
