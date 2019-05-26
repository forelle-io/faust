defmodule Faust.Crypto do
  @moduledoc false

  @alphabets "abcdefghijklmnopqrstuvwxyz"

  def generate_unique_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> binary_part(0, length)
  end

  def generate_unique_alphabet_string(length) do
    alphabets_list = String.split(@alphabets, "", trim: true)

    1..length
    |> Enum.reduce([], fn _, acc -> [Enum.random(alphabets_list) | acc] end)
    |> Enum.join("")
  end
end
