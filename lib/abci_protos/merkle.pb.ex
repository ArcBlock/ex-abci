defmodule Abci.Merkle.ProofOp do
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

defmodule Abci.Merkle.Proof do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          ops: [Abci.Merkle.ProofOp.t()]
        }
  defstruct [:ops]

  field :ops, 1, repeated: true, type: Abci.Merkle.ProofOp
end
