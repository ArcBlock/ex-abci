defmodule ExAbci.Varint do
  @moduledoc """
  Encode and decode varint and zigzag. Maybe there's existing lib for it.
  """
  import Bitwise

  @doc """
  Encodes unsigned integer

  iex> ExAbci.Varint.encode_varint(127)
  "\d"

  iex> "\d" === <<127>>
  true

  iex> ExAbci.Varint.encode_varint(128)
  <<128, 1>>

  iex> ExAbci.Varint.encode_varint(1000)
  <<232, 7>>
  """
  @spec encode_varint(non_neg_integer()) :: binary()
  def encode_varint(v) when v < 128, do: <<v>>
  def encode_varint(v), do: <<1::1, v::7, encode_varint(v >>> 7)::binary>>

  @doc """
  Encodes integer with zigzag

  iex> ExAbci.Varint.encode_zigzag(1)
  <<2>>

  iex> ExAbci.Varint.encode_zigzag(-1)
  <<1>>

  iex> ExAbci.Varint.encode_zigzag(128)
  <<128, 2>>

  iex> ExAbci.Varint.encode_zigzag(-128)
  <<255, 1>>
  """
  @spec encode_zigzag(integer()) :: binary()
  def encode_zigzag(v) when v >= 0, do: encode_varint(v <<< 1)
  def encode_zigzag(v), do: encode_varint(-((v <<< 1) + 1))

  @doc """
  Decodes varint

  iex> ExAbci.Varint.decode_varint(<<127>>)
  {127, ""}

  iex> ExAbci.Varint.decode_varint(<<128, 1>>)
  {128, ""}

  iex> ExAbci.Varint.decode_varint(<<232, 7>>)
  {1000, ""}

  iex> ExAbci.Varint.decode_varint(<<128>>)
  :none
  """
  @spec decode_varint(binary()) :: :none | {non_neg_integer(), binary()}
  def decode_varint(<<0::1, int::7, rest::binary>>), do: {int, rest}

  def decode_varint(<<1::1, int::7, rest::binary>>) do
    case decode_varint(rest) do
      :none -> :none
      {int1, rest1} -> {int + (int1 <<< 7), rest1}
    end
  end

  def decode_varint(_), do: :none

  @doc """
  Decodes zigzag back to integer

  iex> ExAbci.Varint.decode_zigzag(<<2>>)
  {1, ""}

  iex> ExAbci.Varint.decode_zigzag(<<1>>)
  {-1, ""}

  iex> ExAbci.Varint.decode_zigzag(<<128, 2>>)
  {128, ""}

  iex> ExAbci.Varint.decode_zigzag(<<255, 1>>)
  {-128, ""}
  """
  @spec decode_zigzag(binary()) :: :none | {integer(), binary()}
  def decode_zigzag(bin) do
    case decode_varint(bin) do
      :none ->
        :none

      {varint, rest} ->
        int =
          case varint &&& 1 do
            1 -> -((varint + 1) >>> 1)
            0 -> varint >>> 1
          end

        {int, rest}
    end
  end
end
