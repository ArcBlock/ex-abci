defmodule SimpleChain.Wallet do
  @moduledoc """
  Wallet client
  """

  alias SimpleChain.{AccountInfo, Server, Tx, Rpc}

  @type t :: %{
          private_key: String.t(),
          public_key: String.t(),
          address: String.t()
        }

  @doc """
  Create a new eth-like wallet
  """
  @spec new() :: t()
  def new do
    private_key = :crypto.strong_rand_bytes(32)

    {:ok, public_key} = :libsecp256k1.ec_pubkey_create(private_key, :uncompressed)
    <<4::size(8), key::binary-size(64)>> = public_key
    <<_::binary-size(12), address::binary-size(20)>> = :keccakf1600.hash(:sha3_256, key)

    %{
      private_key: Base.encode16(private_key),
      public_key: Base.encode16(public_key),
      address: "0x#{Base.encode16(address)}"
    }
  end

  @doc """
  This is to automatically give user wallet some money if this wallet is not seen in the network, for easily testing purpose
  """
  @spec declare(t()) :: :ok | {:error, any}
  def declare(wallet) do
    tx = Tx.sign(wallet.address, "", 0, 0, wallet.public_key, wallet.private_key)
    Rpc.send(tx)
  end

  @spec transfer(t(), String.t(), non_neg_integer()) :: :ok | {:error, any}
  def transfer(%{address: from, public_key: pub_key, private_key: priv_key}, to, total) do
    nonce = nonce(from)
    tx = Tx.sign(from, to, nonce, total, pub_key, priv_key)
    Rpc.send(tx)
  end

  @spec balance(String.t()) :: non_neg_integer()
  def balance(address) do
    apply(Server, :account_balance, [address])
  end

  @spec nonce(String.t()) :: non_neg_integer()
  def nonce(address) do
    apply(Server, :account_nonce, [address])
  end

  @spec info(String.t()) :: AccountInfo.t()
  def info(address) do
    apply(Server, :account_info, [address])
  end

  @spec chain_info :: map()
  def chain_info do
    apply(Server, :chain_info, [])
  end
end
