defmodule SimpleChain.Tx do
  @moduledoc """
  Transaction manipulation for simple chain
  """
  alias SimpleChain.Transaction

  @spec sign(
          String.t(),
          String.t(),
          non_neg_integer(),
          non_neg_integer(),
          String.t(),
          String.t()
        ) :: :ok | {:error, any}
  def sign(from, to, nonce, total, pub_key, priv_key) do
    hash = sha3(from, to, nonce, total, pub_key)
    signature = ecdsa_sign!(hash, priv_key)

    tx = %Transaction{
      from: from,
      to: to,
      nonce: nonce,
      total: total,
      pub_key: pub_key,
      signature: Base.encode64(signature)
    }

    Transaction.encode(tx)
  end

  @spec verify(Transaction.t()) :: boolean()
  def verify(tx) do
    hash = sha3(tx.from, tx.to, tx.nonce, tx.total, tx.pub_key)
    ecdsa_verify(hash, Base.decode64!(tx.signature), tx.pub_key)
  end

  # priv function
  defp sha3(from, to, nonce, total, pub_key) do
    :keccakf1600.hash(
      :sha3_256,
      from <> to <> Integer.to_string(nonce) <> Integer.to_string(total) <> pub_key
    )
  end

  defp ecdsa_sign!(data, priv_key) do
    {:ok, signature} = :libsecp256k1.ecdsa_sign(data, Base.decode16!(priv_key), :default, <<>>)
    signature
  end

  defp ecdsa_verify(data, signature, pub_key) do
    :libsecp256k1.ecdsa_verify(data, signature, Base.decode16!(pub_key))
  end
end
