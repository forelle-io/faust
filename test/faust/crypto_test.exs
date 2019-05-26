defmodule Faust.CryptoTest do
  @moduledoc false

  use Faust.DataCase

  alias Faust.Crypto

  test "generate_unique_string" do
    assert Crypto.generate_unique_string(8) |> String.length() == 8
  end

  test "generate_unique_alphabet_string" do
    unique_alphabet_string = Crypto.generate_unique_alphabet_string(8)

    assert unique_alphabet_string =~ ~r/\A[a-z]{8}\z/
  end
end
